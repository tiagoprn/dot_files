#!/usr/bin/env bash
# =============================================================================
# rsync_backup.sh — Backup script for enterprise-d
# Runs all sets: A (home dirs), B (/kvm), C (/storage)
# NOTE: --dry-run is active. Remove it when ready for a real sync.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Base rsync flags (shared by all sets)
# -----------------------------------------------------------------------------
RSYNC_FLAGS=(
    -av
    --info=progress2
    --inplace
    --partial
    --delete
    --ignore-errors
    --itemize-changes
    --stats
    --human-readable
    # --dry-run # NOTE: remove this to run the backup effective
)

# -----------------------------------------------------------------------------
# Origins & destinations
# -----------------------------------------------------------------------------
DEST_A="tiago@oa:/media/XTORAGE-5TB/backups/enterprise-d/home-tiago"
SET_A_ORIGINS=(
    /home/tiago/.aws
    /home/tiago/.config
    /home/tiago/.gnupg
    /home/tiago/.mozilla
    /home/tiago/.pi
    /home/tiago/.pki
    /home/tiago/.ssh
    /home/tiago/Downloads
    /home/tiago/Pictures
    /home/tiago/Videos
    /home/tiago/Wallpapers
    /home/tiago/books
    /home/tiago/contractors
    /home/tiago/images
    /home/tiago/references
    /home/tiago/screenshots
    /home/tiago/tmp
)

ORIGIN_B="/kvm"
DEST_B="tiago@oa:/media/XTORAGE-5TB/backups/enterprise-d"

ORIGIN_C="/storage"
DEST_C="tiago@oa:/media/XTORAGE-5TB/backups/enterprise-d"

# Colour helpers
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_set() {
    echo -e "\n${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  SET ${1}${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
}
log_item() { echo -e "${YELLOW}▶  ${1}${NC}"; }
log_ok() { echo -e "${GREEN}✔  Done: ${1}${NC}"; }
log_err() { echo -e "${RED}✘  Error on: ${1}${NC}" >&2; }

# -----------------------------------------------------------------------------
# SET A — individual home subdirs → remote home-tiago/
# -----------------------------------------------------------------------------
log_set "A  |  Home dirs  →  ${DEST_A}/"

for ORIGIN in "${SET_A_ORIGINS[@]}"; do
    log_item "${ORIGIN}  →  ${DEST_A}/"
    if time rsync "${RSYNC_FLAGS[@]}" "${ORIGIN}" "${DEST_A}/"; then
        log_ok "${ORIGIN}"
    else
        log_err "${ORIGIN}"
    fi
done

# -----------------------------------------------------------------------------
# SET B — /kvm → remote enterprise-d/
# -----------------------------------------------------------------------------
log_set "B  |  ${ORIGIN_B}  →  ${DEST_B}/"

log_item "${ORIGIN_B}  →  ${DEST_B}/"
if time rsync "${RSYNC_FLAGS[@]}" "${ORIGIN_B}" "${DEST_B}/"; then
    log_ok "${ORIGIN_B}"
else
    log_err "${ORIGIN_B}"
fi

# -----------------------------------------------------------------------------
# SET C — /storage → remote enterprise-d/
# -----------------------------------------------------------------------------
log_set "C  |  ${ORIGIN_C}  →  ${DEST_C}/"

log_item "${ORIGIN_C}  →  ${DEST_C}/"
if time rsync "${RSYNC_FLAGS[@]}" "${ORIGIN_C}" "${DEST_C}/"; then
    log_ok "${ORIGIN_C}"
else
    log_err "${ORIGIN_C}"
fi

# -----------------------------------------------------------------------------
echo -e "\n${GREEN}══════════════════════════════════════════════${NC}"
echo -e "${GREEN}  All sets completed.${NC}"
echo -e "${GREEN}══════════════════════════════════════════════${NC}\n"
