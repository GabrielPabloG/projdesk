#!/usr/bin/env bash

trash_count() {
    local count=0
    local dir
    for dir in "$TRASH_DIR"/*/; do
        [ -d "$dir" ] || continue
        count=$((count + 1))
    done
    echo "$count"
}

trash_purge_expired() {
    local now
    now=$(date +%s)
    local dir info timestamp age
    for dir in "$TRASH_DIR"/*/; do
        [ -d "$dir" ] || continue
        info="${dir}.trash_info"
        if [ -f "$info" ]; then
            timestamp=$(cat "$info")
            age=$((now - timestamp))
            if [ "$age" -gt "$((TRASH_MAX_DAYS * 86400))" ]; then
                rm -rf "$dir"
            fi
        fi
    done
}

remove_project() {
    local force=false
    local project_args=()

    while [ $# -gt 0 ]; do
        case "$1" in
            --force|-f)
                force=true
                shift
                ;;
            *)
                project_args+=("$1")
                shift
                ;;
        esac
    done

    if [ "${#project_args[@]}" -ge 1 ] && [ "${project_args[0]}" = "all" ]; then
        if [ "${#project_args[@]}" -gt 1 ]; then
            t remove_all_usage
            return 1
        fi
        local all_projects=()
        for dir in "$PROJECTS_DIR"/*; do
            [ -d "$dir" ] || continue
            all_projects+=("$(basename "$dir")")
        done

        if [ "${#all_projects[@]}" -eq 0 ]; then
            t remove_all_empty
            return 0
        fi

        if [ "$force" != true ]; then
            t remove_all_confirm "${#all_projects[@]}"
            local reply
            read -r reply
            if ! [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]; then
                t remove_aborted
                return 0
            fi
        fi

        project_args=("${all_projects[@]}")
    fi

    if [ "${#project_args[@]}" -eq 0 ]; then
        t remove_usage 3
        return 1
    fi

    if [ "${#project_args[@]}" -gt 3 ] && [ "$force" != true ]; then
        t remove_max_args 3
        return 1
    fi

    local projects=()
    local resolved_paths=()
    local proj RESOLVED rc
    for proj in "${project_args[@]}"; do
        RESOLVED=$(resolve_project "$proj" 2>&1)
        rc=$?
        if [ "$rc" -ne 0 ]; then
            printf '%s\n' "$RESOLVED" >&2
            return 1
        fi
        projects+=("$(basename "$RESOLVED")")
        resolved_paths+=("$RESOLVED")
    done

    trash_purge_expired

    local deleted_count=0
    local trashed_count=0
    local skipped_count=0
    local i
    for i in "${!projects[@]}"; do
        local name="${projects[$i]}"
        local path="${resolved_paths[$i]}"

        if [ "$force" = true ]; then
            rm -rf "$path"
            recent_remove "$name"
            deleted_count=$((deleted_count + 1))
            t remove_force_success "$name"
            continue
        fi

        local count
        count=$(trash_count)

        if [ "$count" -lt "$TRASH_MAX_ITEMS" ]; then
            mkdir -p "$TRASH_DIR"
            rm -rf "${TRASH_DIR:?}/${name:?}"
            mv "$path" "$TRASH_DIR/$name"
            date +%s > "$TRASH_DIR/$name/.trash_info"
            recent_remove "$name"
            trashed_count=$((trashed_count + 1))
            t remove_success "$name"
        else
            t remove_trash_full "$TRASH_MAX_ITEMS" "$TRASH_MAX_ITEMS" "$name"
            local reply
            read -r reply
            if [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]; then
                rm -rf "$path"
                recent_remove "$name"
                deleted_count=$((deleted_count + 1))
                t remove_force_success "$name"
            else
                skipped_count=$((skipped_count + 1))
                t remove_skipped "$name"
            fi
        fi
    done
}
