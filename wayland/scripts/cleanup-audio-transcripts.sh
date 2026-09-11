#!/usr/bin/env bash
# cleanup-audio-transcripts.sh — batch-clean whisper-cli transcripts with S1-mini via llama.cpp server.
#
# USAGE: cleanup-audio-transcripts.sh <folder-with-transcripts> [styling] [structure] [context]
#   styling:   casual | semi-casual | semi-formal | formal   (default semi-formal)
#   structure: prose | lists                                  (default prose)
#   context:   general | email                                (default general)
#
# REQUIRES: llama-server on localhost:8080 (CPU build is fine), jq, python3.
#
# Long transcripts are auto-chunked at sentence boundaries (~900 tokens per pass).
#
# HOW IT WORKS:
#
# This script batch-cleans dictated transcripts using a small, locally-run AI
# model (Superwhisper's S1-mini). Raw speech-to-text output captures everything
# the speaker said, including filler words, false starts, and self-corrections,
# which makes it accurate but hard to read. This script takes the raw transcript
# files produced by whisper-cli and rewrites each one as clean, readable text:
# filler words are removed, mid-sentence corrections are resolved to the speaker's
# final choice, spoken numbers and email addresses are formatted, and punctuation
# is added. The model performs only this normalization task and does not invent,
# summarize, or otherwise alter content. For each .txt file in the target folder,
# the script strips timestamp prefixes, splits long transcripts into chunks of
# roughly 900 tokens (the model processes a limited amount of text at a time, and
# output quality degrades beyond that limit), and formats each chunk according to
# the input structure the model was trained on: a control line specifying style,
# structure, and context, followed by the raw text. The chunks are processed by
# llama-server, which runs the model on the local CPU; reading the input is fast,
# while generating the cleaned text word by word is the slow part, so processing
# time scales with transcript length. The cleaned chunks are then joined into a
# .clean.txt file next to each original. Everything runs locally: no data leaves
# the machine, there are no API costs, and an empty result (for example, a
# recording containing only filler words) is treated as a valid outcome rather
# than an error.

set -euo pipefail

DIR="${1:?Usage: cleanup-audio-transcripts.sh <folder> [styling] [structure] [context]}"
STYLING="${2:-semi-formal}"
STRUCTURE="${3:-prose}"
CONTEXT="${4:-general}"
SERVER="http://localhost:8080"

SYSTEM='You are a text normalizer for speech-to-text transcripts. The input begins with a control line specifying the styling, structure, and context settings; clean the transcript to match those settings and output only the cleaned text.'

for f in "$DIR"/*.txt; do
    [ -e "$f" ] || {
        echo "No .txt files in $DIR"
        exit 1
    }
    out="${f%.txt}.clean.txt"
    # Strip whisper-cli timestamp prefixes like [00:00:00] or [00:00:00.000 --> ...] if present
    transcript=$(sed -E 's/^\[[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?( *--> *\[[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?)?\] *//' "$f")
    [ -n "$transcript" ] || continue # -n: non-empty STRING (an -s test here was a bug: it checks files)

    # Chunk at sentence boundaries (~3,600 chars ~ 900 tokens, under the ~1,000-token input limit).
    # python3 prints chunks separated by a <<<CHUNK>>> marker line.
    chunks=$(printf '%s' "$transcript" | python3 -c '
import sys, re
text = sys.stdin.read().strip()
MAX = 3600
sents = re.split(r"(?<=[.!?])\s+", text) if re.search(r"[.!?]", text) else [text]
chunks, cur = [], ""
for s in sents:
    if cur and len(cur) + 1 + len(s) > MAX:
        chunks.append(cur); cur = s
    else:
        cur = (cur + " " + s).strip()
if cur: chunks.append(cur)
# hard-split any single sentence still over MAX (punctuation-less transcripts)
final = []
for c in chunks:
    while len(c) > MAX:
        cut = c.rfind(" ", 0, MAX)
        cut = cut if cut > 0 else MAX
        final.append(c[:cut]); c = c[cut:].strip()
    final.append(c)
sys.stdout.write("\n<<<CHUNK>>>\n".join(final))
')
    n_chunks=$(printf '%s\n' "$chunks" | grep -c '^<<<CHUNK>>>$' || true)
    n_chunks=$((n_chunks + 1))
    if [ "$n_chunks" -gt 1 ]; then
        echo "chunking: $(basename "$f") -> $n_chunks passes" >&2
    fi

    # Clean each chunk; empty result is VALID (filler-only input) and yields an empty part.
    cleaned=""
    while IFS= read -r chunk; do
        [ -n "$chunk" ] || continue
        control="[Styling: $STYLING] [Structure: $STRUCTURE] [Context: $CONTEXT]"
        payload=$(jq -n --arg sys "$SYSTEM" --arg user "$control
$chunk" '{messages:[{role:"system",content:$sys},{role:"user",content:$user}],temperature:0}')
        part=$(curl -s "$SERVER/v1/chat/completions" -H 'Content-Type: application/json' -d "$payload" | jq -r '.choices[0].message.content')
        if [ -n "$cleaned" ]; then cleaned="$cleaned $part"; else cleaned="$part"; fi
    done <<<"$chunks"

    printf '%s' "$cleaned" >"$out"
    echo "cleaned: $f -> $out"
done
