#!/usr/bin/env bash
#
# import-to-pass.sh - insert the YAML files made by json-to-yaml.py into pass.
#
# Prompts for the export folder (or takes it as the only argument), then adds
# every *.yaml file as one pass key. The file name splits on its first dot:
#
#   <prefix>.<slug>.yaml  ->  BTWRDN-IMPORTED/<prefix>/<slug>
#
# Example: _sample_.zoom-us.yaml -> BTWRDN-IMPORTED/_sample_/zoom-us
#
# pass creates the store folders itself and encrypts with the nearest .gpg-id,
# so BTWRDN-IMPORTED/.gpg-id covers every prefix below it. Each insert asks
# your gpg-agent pinentry for the passphrase once the agent cache is warm.
# Passwords are never printed or logged.
#
# Usage:  import-to-pass.sh [yaml-folder]
#
# After the import every entry is verified: the stored key is decrypted and
# compared against its source file, trailing newlines excluded on both sides,
# so a trailing-newline round-trip quirk can never fake a mismatch.
#
# Exit codes: 0 all keys inserted and verified, 1 folder invalid or empty,
# 2 some insert failed, 3 a stored entry is missing, unreadable or differs.

set -euo pipefail

readonly store_folder="BTWRDN-IMPORTED"

timestamp() {
	date '+%Y-%m-%d %H:%M:%S'
}

log_info() {
	printf '%s INFO  %s\n' "$(timestamp)" "$1"
}

log_warn() {
	printf '%s WARN  %s\n' "$(timestamp)" "$1" >&2
}

log_error() {
	printf '%s ERROR %s\n' "$(timestamp)" "$1" >&2
}

# Read the folder from the argument, or prompt for it.
# Prints the chosen path on stdout, or returns 1 when none was given.
prompt_folder() {
	local chosen="${1:-}"

	if [[ -z "$chosen" ]]; then
		printf 'YAML folder: ' >&2
		IFS= read -r chosen || true
	fi
	if [[ -z "$chosen" ]]; then
		log_error "no YAML folder given"
		return 1
	fi
	printf '%s\n' "$chosen"
}

# Insert every *.yaml file of the folder as one pass key.
# Returns 1 when the folder is unusable, 2 when some entry failed.
import_folder() {
	local yaml_folder="$1"
	local file base prefix slug key
	local found=0 inserted=0 skipped=0 failed=0

	if [[ ! -d "$yaml_folder" ]]; then
		log_error "not a folder: $yaml_folder"
		return 1
	fi

	local files=()
	shopt -s nullglob
	files=("$yaml_folder"/*.yaml)
	shopt -u nullglob

	if ((${#files[@]} == 0)); then
		log_error "no .yaml files in $yaml_folder"
		return 1
	fi

	for file in "${files[@]}"; do
		found=$((found + 1))
		base="$(basename -- "$file" .yaml)"

		# Split on the first dot only: prefix is the folder, the rest is the key.
		prefix="${base%%.*}"
		slug="${base#*.}"
		if [[ -z "$prefix" || -z "$slug" || "$prefix" == "$base" ]]; then
			log_error "bad file name (needs <prefix>.<slug>.yaml): $(basename -- "$file")"
			failed=$((failed + 1))
			continue
		fi

		key="$store_folder/$prefix/$slug"
		if [[ -e "${PASSWORD_STORE_DIR:-$HOME/.password-store}/$key.gpg" ]]; then
			log_warn "already in the store, skipping: $key"
			skipped=$((skipped + 1))
			continue
		fi

		log_info "inserting $key"
		if ! pass insert -m "$key" <"$file" >/dev/null; then
			log_error "FAILED: $key"
			failed=$((failed + 1))
			continue
		fi
		inserted=$((inserted + 1))
	done

	log_info "summary: found=$found inserted=$inserted skipped=$skipped failed=$failed"
	((failed == 0)) || return 2
	return 0
}

# Verify every key in the store against its source YAML file.
# Returns 1 when the folder has no files, 3 when any entry differs.
verify_folder() {
	local yaml_folder="$1"
	local file base prefix slug key stored
	local checked=0 mismatches=0
	local store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"

	local files=()
	shopt -s nullglob
	files=("$yaml_folder"/*.yaml)
	shopt -u nullglob

	if ((${#files[@]} == 0)); then
		log_error "no .yaml files to verify in $yaml_folder"
		return 1
	fi

	for file in "${files[@]}"; do
		base="$(basename -- "$file" .yaml)"
		prefix="${base%%.*}"
		slug="${base#*.}"
		if [[ -z "$prefix" || -z "$slug" || "$prefix" == "$base" ]]; then
			# A name without a dot already failed in import_folder.
			continue
		fi

		key="$store_folder/$prefix/$slug"
		if [[ ! -e "$store/$key.gpg" ]]; then
			log_error "verify MISSING: $key"
			mismatches=$((mismatches + 1))
			continue
		fi
		if ! stored="$(pass show "$key" 2>/dev/null)"; then
			# A decrypt failure must not masquerade as a content mismatch.
			log_error "verify UNREADABLE: $key"
			mismatches=$((mismatches + 1))
			continue
		fi

		# $(...) strips trailing newlines on both sides, so a trailing-newline
		# round-trip quirk can never fake a mismatch. Every other byte,
		# including any real edit, must still match exactly.
		if [[ "$stored" == "$(cat -- "$file")" ]]; then
			checked=$((checked + 1))
		else
			log_error "verify MISMATCH: $key"
			mismatches=$((mismatches + 1))
		fi
	done

	log_info "verify: ok=$checked mismatches=$mismatches"
	((mismatches == 0)) || return 3
	return 0
}

main() {
	local yaml_folder import_rc=0 verify_rc=0
	yaml_folder="$(prompt_folder "${1:-}")"

	log_info "yaml folder: $yaml_folder"
	import_folder "$yaml_folder" || import_rc=$?
	verify_folder "$yaml_folder" || verify_rc=$?

	((import_rc == 0)) || return "$import_rc"
	return "$verify_rc"
}

main "$@"
