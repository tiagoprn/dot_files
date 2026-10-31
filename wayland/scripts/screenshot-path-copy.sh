#!/usr/bin/env bash
#
# screenshot-path-copy.sh
#
# Launch wayscriber, watch the capture folder, and copy the path of the first
# new file to the Wayland clipboard with wl-copy, then notify with notify-send.
#
# The watcher runs in the background so the copy fires as soon as the file
# appears, even while the wayscriber overlay stays open after the capture.
# Every stage is appended to log_file so a failed run can be traced later.
#
# Usage: screenshot-path-copy.sh
# Exit status: that of wayscriber.

set -euo pipefail

readonly capture_dir="${HOME}/screenshots"
readonly notify_title="Screenshot"
readonly poll_interval="0.3"
readonly log_file="${HOME}/.local/state/hyprland/screenshot-path-copy.log"

log() {
  printf '%s %s\n' "$(date '+%F %T')" "$*" >>"$log_file"
}

# Newest file in capture_dir that appeared after the marker was written.
# Prints the full path, or nothing when there is no new file yet.
newest_new_file() {
  find "$capture_dir" -maxdepth 1 -type f -newer "$marker" -printf '%T@ %p\n' 2>/dev/null |
    sort -rn |
    head -n 1 |
    cut -d ' ' -f2-
}

copy_and_notify() {
  local file_path="$1"
  if printf '%s' "$file_path" | wl-copy; then
    log "wl-copy ok: $file_path"
  else
    log "wl-copy FAILED rc=$? for $file_path"
  fi
  if notify-send "$notify_title" "Path copied to clipboard: $file_path"; then
    log "notify-send ok"
  else
    log "notify-send FAILED rc=$?"
  fi
}

# Poll until a file newer than the marker shows up, then copy and notify.
# The condition form keeps set -e from killing the loop when find matches nothing.
watch_for_capture() {
  local newest=""
  while true; do
    if newest="$(newest_new_file)" && [[ -n "$newest" ]]; then
      log "new capture detected: $newest"
      copy_and_notify "$newest"
      return 0
    fi
    sleep "$poll_interval"
  done
}

# wayscriber --active returns as soon as the overlay process is up (it
# detaches), so wait until a wayscriber process shows, then until every one
# of them is gone. Only then may the EXIT trap kill the watcher.
wait_for_overlay() {
  local waited=0
  while ! pgrep -x wayscriber >/dev/null 2>&1; do
    sleep 0.2
    waited=$((waited + 1))
    if ((waited >= 25)); then
      log "no wayscriber process appeared within 5s, exiting"
      return 0
    fi
  done
  log "overlay up, watcher stays alive until it closes"
  while pgrep -x wayscriber >/dev/null 2>&1; do
    sleep 0.3
  done
  log "overlay closed"
}

cleanup() {
  rm -f "$marker"
  if [[ -n "$watcher_pid" ]]; then
    kill "$watcher_pid" 2>/dev/null || true
    wait "$watcher_pid" 2>/dev/null || true
  fi
}

marker=""
watcher_pid=""

mkdir -p "${log_file%/*}"
marker="$(mktemp)"
log "start capture_dir=$capture_dir marker=$marker"
if [[ ! -d "$capture_dir" ]]; then
  log "ERROR capture dir missing: $capture_dir"
fi

trap cleanup EXIT

watch_for_capture &
watcher_pid=$!
log "watcher started pid=$watcher_pid"

wayscriber --active
log "wayscriber returned rc=$?"
wait_for_overlay
