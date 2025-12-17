#!/usr/bin/env bash

set -eou pipefail

fs_ressources_diag() {
    # echo "DEBUG: Starting fs_ressources_diag..." >&2

    # Ensure USER is set, otherwise default to current user ID name
    local current_user="${USER:-$(id -un)}"
    # echo "DEBUG: Resolved user to: ${current_user}" >&2

    local file_curr file_max h_ulimit s_ulimit

    # echo "DEBUG: retrieving file-nr..." >&2
    file_curr="$(awk '{print $1}' /proc/sys/fs/file-nr)"

    # echo "DEBUG: retrieving file-max..." >&2
    file_max="$(cat /proc/sys/fs/file-max)"

    # echo "DEBUG: retrieving ulimits..." >&2
    h_ulimit="$(ulimit -Hn)"
    s_ulimit="$(ulimit -Sn)"

    # Generate list of paths to search: /proc/<pid>/fd
    # We use sed to format them and tr to linearize for the find command
    # || true ensures we don't fail if pgrep returns nothing (unlikely)
    local search_paths
    # echo "DEBUG: building search paths..." >&2
    search_paths="$(pgrep -u "${current_user}" | sed 's|^|/proc/|; s|$|/fd|' | tr '\n' ' ' || true)"

    local inotify_instances_curr inotify_watches_curr

    if [[ -z $search_paths ]]; then
        # echo "DEBUG: No search paths found (no processes for user?)" >&2
        inotify_instances_curr=0
        inotify_watches_curr=0
    else
        # echo "DEBUG: Counting inotify instances..." >&2
        # Count inotify instances
        # - find might fail if process vanishes (ignoring stderr)
        # - || true prevents script exit due to set -e/pipefail if find returns non-zero
        inotify_instances_curr="$(find ${search_paths} -lname anon_inode:inotify 2>/dev/null | wc -l || true)"

        # echo "DEBUG: Counting inotify watches..." >&2
        # Count inotify watches
        # Structure:
        # 1. find: locate inotify fds and print corresponding fdinfo path
        # 2. xargs grep: count "inotify" occurrences in fdinfo files
        # 3. awk: sum the counts
        # We use { ... || true; } for grep to prevent non-zero exit code when no matches are found
        # We use s+0 in awk to ensure "0" is printed if input is empty
        inotify_watches_curr="$(find ${search_paths} -lname anon_inode:inotify -printf '%hinfo/%f\n' 2>/dev/null \
            | { xargs grep -chE "^inotify" 2>/dev/null || true; } \
            | awk '{s+=$1} END {print s+0}' || true)"
    fi

    local inotify_instances_max inotify_watches_max
    # echo "DEBUG: Retrieving max inotify limits..." >&2
    inotify_instances_max="$(cat /proc/sys/fs/inotify/max_user_instances)"
    inotify_watches_max="$(cat /proc/sys/fs/inotify/max_user_watches)"

    # echo "DEBUG: Outputting results..." >&2
    echo "System"
    echo "    Open file handles: Current=${file_curr} / Max=${file_max}"
    echo "Current process"
    echo "    Open file handles: Hard=${h_ulimit} / Soft=${s_ulimit}"
    echo "User"
    echo "    Inotify instances: Current=${inotify_instances_curr} / Max=${inotify_instances_max}"
    echo "    Inotify watches:   Current=${inotify_watches_curr} / Max=${inotify_watches_max}"
}

# echo "DEBUG: Script started." >&2
fs_ressources_diag
