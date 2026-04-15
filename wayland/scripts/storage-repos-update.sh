#!/usr/bin/env bash
# =============================================================================
# storage-repos-update.sh — Pull latest changes for all /storage/src repos
# Stashes uncommitted changes (including untracked) before pulling,
# then restores them. Prints a color-coded summary report at the end.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
readonly REPOS_ROOT=/storage/src
readonly REPOS="dot_files devops pde.nvim aikt pi-session nix-home-manager"

# -----------------------------------------------------------------------------
# Color helpers
# -----------------------------------------------------------------------------
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# -----------------------------------------------------------------------------
# Logging functions
# -----------------------------------------------------------------------------
log_info() { printf "${CYAN}▶  %s${NC}\n" "$1"; }
log_ok() { printf "${GREEN}✔  %s${NC}\n" "$1"; }
log_warn() { printf "${YELLOW}⚠  %s${NC}\n" "$1"; }
log_error() { printf "${RED}✘  %s${NC}\n" "$1" >&2; }

# -----------------------------------------------------------------------------
# Result arrays — accumulate repo names per category
# -----------------------------------------------------------------------------
updated_repos=()
unchanged_repos=()
skipped_repos=()
error_repos=()

# -----------------------------------------------------------------------------
# Main loop
# -----------------------------------------------------------------------------
for repo in $REPOS; do
    full_path="${REPOS_ROOT}/${repo}"

    # --- Validate: directory exists and is a git repo ---
    if [[ ! -d "${full_path}" ]]; then
        log_error "${repo}: directory not found, skipping"
        skipped_repos+=("${repo}")
        continue
    fi

    if ! git -C "${full_path}" rev-parse --git-dir &>/dev/null; then
        log_error "${repo}: not a git repository, skipping"
        skipped_repos+=("${repo}")
        continue
    fi

    # --- Step 1: Stash uncommitted changes if any ---
    was_stashed=false
    if [[ -n "$(git -C "${full_path}" status --porcelain)" ]]; then
        log_info "${repo}: stashing uncommitted changes..."
        if git -C "${full_path}" stash --include-untracked -q; then
            was_stashed=true
            log_ok "${repo}: stash successful"
        else
            log_error "${repo}: failed to stash, skipping pull"
            error_repos+=("${repo}")
            continue
        fi
    fi

    # --- Step 2: Pull latest changes ---
    pull_output=""
    if pull_output=$(git -C "${full_path}" pull 2>&1); then
        if echo "${pull_output}" | grep -q "Already up to date"; then
            log_ok "${repo}: already up to date"
            unchanged_repos+=("${repo}")
        else
            log_ok "${repo}: updated"
            updated_repos+=("${repo}")
        fi
    else
        log_error "${repo}: git pull failed — ${pull_output}"
        error_repos+=("${repo}")
        # Still attempt stash pop if we stashed, so user doesn't lose work
        if ${was_stashed}; then
            if git -C "${full_path}" stash pop -q 2>&1; then
                log_ok "${repo}: stash restored after failed pull"
            else
                log_error "${repo}: stash pop also failed — manual resolution needed"
            fi
        fi
        continue
    fi

    # --- Step 3: Restore stashed changes if we stashed ---
    if ${was_stashed}; then
        if git -C "${full_path}" stash pop -q 2>&1; then
            log_ok "${repo}: stash restored"
        else
            log_error "${repo}: stash pop has conflicts — manual resolution needed"
            error_repos+=("${repo}")
            continue
        fi
    fi
done

# -----------------------------------------------------------------------------
# Report summary
# -----------------------------------------------------------------------------
printf '\n'
printf '%b' "${CYAN}══════════════════════════════════════════════${NC}\n"
printf '%b' "${CYAN}  UPDATE SUMMARY${NC}\n"
printf '%b' "${CYAN}══════════════════════════════════════════════${NC}\n"

if [[ ${#updated_repos[@]} -gt 0 ]]; then
    printf '%b' "${GREEN}  Updated:${NC}\n"
    for repo in "${updated_repos[@]}"; do
        printf '%b' "${GREEN}    ✔ ${repo}${NC}\n"
    done
fi

if [[ ${#unchanged_repos[@]} -gt 0 ]]; then
    printf '%b' "${YELLOW}  Unchanged:${NC}\n"
    for repo in "${unchanged_repos[@]}"; do
        printf '%b' "${YELLOW}    • ${repo}${NC}\n"
    done
fi

if [[ ${#skipped_repos[@]} -gt 0 ]]; then
    printf '%b' "${RED}  Skipped (not a git repo):${NC}\n"
    for repo in "${skipped_repos[@]}"; do
        printf '%b' "${RED}    ✘ ${repo}${NC}\n"
    done
fi

if [[ ${#error_repos[@]} -gt 0 ]]; then
    printf '%b' "${RED}  Errors:${NC}\n"
    for repo in "${error_repos[@]}"; do
        printf '%b' "${RED}    ✘ ${repo}${NC}\n"
    done
fi

printf '%b' "${CYAN}══════════════════════════════════════════════${NC}\n"
printf '\n'
