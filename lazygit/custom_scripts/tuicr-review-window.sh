#!/usr/bin/env bash
set -euo pipefail

if ! command -v tuicr >/dev/null 2>&1; then
  echo "[tuicr] ERROR: tuicr not found in PATH"
  read -r -p "[tuicr] Press ENTER to close this window" _
  exit 1
fi

OUT_DIR="${TUICR_REVIEW_DIR:-$HOME/tmp/tuicr-reviews}"
mkdir -p "$OUT_DIR"
OUT_FILE="$OUT_DIR/review-$(date +%Y%m%d-%H%M%S).md"

echo "[tuicr] Review will be saved to: $OUT_FILE"
tuicr "$@" --stdout > "$OUT_FILE"
echo
if [[ -s "$OUT_FILE" ]]; then
  echo "[tuicr] Saved review to: $OUT_FILE"
else
  echo "[tuicr] No review exported (exited without y/ZZ/:wq). Nothing saved."
  rm -f "$OUT_FILE"
fi
read -r -p "[tuicr] Press ENTER to close this window" _
