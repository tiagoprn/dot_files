#!/usr/bin/env bash
# capture-hyprland-death.sh : snapshot every piece of evidence at the moment an
# unclean Hyprland exit is logged, so the investigation no longer depends on a
# human running the runbook while the machine is unattended.
#
# Per death it writes a timestamped directory under
# ~/.local/state/hyprland/death/ containing:
#   launcher-line.txt            the exact journal line that triggered it
#   ftrace-signal_generate.txt   signal number, origin and sender (decisive)
#   audit-hyprsig.txt            every signal-delivery syscall today
#   audit-hyprkill.txt           the SIGKILL-only view, kept for continuity
#   journal-window.txt           the whole journal for the 30 s before the death
#   pypr-tail.txt                the compositor event clock tail
#   pypr-starved.txt             pypr's death marker with its millisecond stamp
#   cores.txt                    coredumps from the last two minutes
#   packages.txt                 current hyprland stack versions
#
# Started from autostart.lua on every compositor start. Single instance via
# flock, so a safe-mode instance never starts a second copy.
#
# Stop it by killing its whole process group, not just the top pid: the pipeline
# subshell inherits the lock fd and keeps the lock held otherwise.
#
# Self-test without faking a real death (keeps the ledger grep clean):
#   HYPR_CAPTURE_PATTERN=CAPTURE-SELFTEST ~/scripts/capture-hyprland-death.sh &
#   logger -t capture-selftest CAPTURE-SELFTEST
set -uo pipefail

DEST="$HOME/.local/state/hyprland/death"
PATTERN="${HYPR_CAPTURE_PATTERN:-Hyprland exit not-cleanly}"

mkdir -p "$DEST" || exit 1
exec 8>>"$DEST/.capture.lock" || exit 1
flock -n 8 || exit 0

note() { printf '%s %s\n' "$(date -Is)" "$*" >>"$DEST/events.log"; }
note "death-capture watcher started (pid $$, pattern: $PATTERN)"

journalctl -f -n 0 -o short-precise 2>/dev/null | while IFS= read -r line; do
    case "$line" in
        *"$PATTERN"*) ;;
        *) continue ;;
    esac

    stamp=$(date +%Y%m%d-%H%M%S)
    out="$DEST/$stamp"
    mkdir -p "$out" || continue
    printf '%s\n' "$line" >"$out/launcher-line.txt"
    note "TRIGGER: $stamp :: $line"

    # Every command below gets </dev/null. This loop's own stdin is the
    # journalctl stream, and ausearch reads stdin whenever stdin is not a
    # terminal: without the redirect it swallows journal lines and blocks.
    sudo -n cat /sys/kernel/tracing/trace >"$out/ftrace-signal_generate.txt" 2>&1 </dev/null
    sudo -n sh -c ': > /sys/kernel/tracing/trace' 2>/dev/null </dev/null

    sudo -n timeout 30 ausearch -if /var/log/audit/audit.log -k hyprsig -ts today \
        >"$out/audit-hyprsig.txt" 2>&1 </dev/null
    # read-this-first extract: senders and signals of the last ten minutes,
    # with the two known-benign senders (the virsh watch loop and its helper)
    # removed so the file stays readable. The unfiltered full day is above.
    {
        echo "# ausearch -k hyprsig -ts recent, SYSCALL lines only"
        echo "# comm=virsh and comm=pkttyagent excluded as known-benign noise"
        sudo -n timeout 30 ausearch -if /var/log/audit/audit.log -k hyprsig -ts recent </dev/null 2>/dev/null \
            | grep "type=SYSCALL" | grep -v 'comm="virsh"' | grep -v 'comm="pkttyagent"'
    } >"$out/audit-hyprsig-recent-syscalls.txt"
    sudo -n timeout 30 ausearch -if /var/log/audit/audit.log -k hyprkill -ts today \
        >"$out/audit-hyprkill.txt" 2>&1 </dev/null

    journalctl --since "$(date -d '-30 seconds' '+%F %T')" --no-pager -o short-precise \
        >"$out/journal-window.txt" 2>&1 </dev/null
    tail -n 60 "$HOME/.local/state/hyprland/pypr.log" >"$out/pypr-tail.txt" 2>&1 </dev/null
    grep "Reader starved" "$HOME/.local/state/hyprland/pypr.log" 2>/dev/null | tail -3 \
        >"$out/pypr-starved.txt" 2>&1
    coredumpctl list --since "-2 minutes" --no-pager >"$out/cores.txt" 2>&1 </dev/null
    pacman -Q hyprland aquamarine hyprutils >"$out/packages.txt" 2>&1 </dev/null

    note "captured: $out"
    sleep 15    # let the replacement instance settle before watching again
done
