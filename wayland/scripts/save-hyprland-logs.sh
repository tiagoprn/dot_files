#!/usr/bin/env bash
# save-hyprland-logs.sh : keep persistent copies of every Hyprland instance log.
#
# Why: /run/user/1000/hypr/<sig>/ is tmpfs. A killed compositor leaves an
# unflushed log tail, and the whole instance directory is recycled shortly
# after. This watcher copies each instance log (on change, at most every
# SAVE_EVERY seconds) into $DEST, records the exact moment an instance
# directory disappears, and prunes old copies.
#
# Started from hyprland.start (see autostart.lua). single instance enforced
# with flock, so repeated hyprland.start hook runs are harmless.

SAVE_EVERY=5
KEEP=100
DEST="$HOME/.local/state/hyprland/keep"

mkdir -p "$DEST" || exit 1

exec 9>>"$DEST/.watcher.lock" || exit 1
flock -n 9 || exit 0

log() { printf '%s %s\n' "$(date -Is)" "$*" >> "$DEST/events.log"; }

declare -A SEEN=()

log "watcher started (pid $$)"

while sleep "$SAVE_EVERY"; do
    # copy changed instance logs
    for dir in /run/user/1000/hypr/*/; do
        [ -d "$dir" ] || continue
        sig=${dir%/}
        sig=${sig##*/}
        file="$dir/hyprland.log"
        [ -f "$file" ] || continue
        size=$(stat -Lc%s "$file" 2>/dev/null) || continue
        if [ -z "${SEEN[$sig]:-}" ]; then
            cp -f "$dir/hyprland.lock" "$DEST/$sig.lock" 2>/dev/null
            if [ -f "$dir/recoverycfg.lua" ]; then
                cp -f "$dir/recoverycfg.lua" "$DEST/$sig.recoverycfg.lua"
            fi
        fi
        saved="$DEST/$sig.log"
        if [ ! -f "$saved" ] || [ "$(stat -c%s "$saved" 2>/dev/null)" -lt "$size" ]; then
            cp -f "$file" "$saved"
        fi
        SEEN[$sig]=1
    done

    # record vanish events (the death moment, to the second)
    for sig in "${!SEEN[@]}"; do
        if [ ! -d "/run/user/1000/hypr/$sig" ]; then
            log "INSTANCE VANISHED: $sig"
            unset 'SEEN[$sig]'
        fi
    done

    # prune oldest saves, never touching events.log
    mapfile -t old < <(ls -1t "$DEST"/*.log 2>/dev/null | tail -n +$((KEEP + 1)))
    for f in "${old[@]}"; do
        [ "$(basename "$f")" = "events.log" ] && continue
        rm -f "$f"
    done
done
