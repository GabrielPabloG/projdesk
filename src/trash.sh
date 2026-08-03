#!/usr/bin/env bash

trash() {
    case "${1:-}" in
        list|ls)
            trash_list
            ;;
        empty)
            trash_empty
            ;;
        remove|rm)
            shift
            trash_remove "$@"
            ;;
        restore)
            shift
            trash_restore "$@"
            ;;
        *)
            trash_list
            echo ""
            echo "🔹 $(t trash_commands_title)"
            printf "  %-28s %s\n" "pd t | trash"          "$(t trash_cmd_list)"
            printf "  %-28s %s\n" "pd t empty"           "$(t trash_cmd_empty)"
            printf "  %-28s %s\n" "pd t rm <name|all>"  "$(t trash_cmd_remove)"
            printf "  %-28s %s\n" "pd t restore <name>"  "$(t trash_cmd_restore)"
            printf "  %-28s %s\n" "pd t restore all"     "$(t trash_cmd_restore_all)"
            ;;
    esac
}

trash_list() {
    local count=0
    for dir in "$TRASH_DIR"/*/; do
        [ -d "$dir" ] || continue
        count=$((count + 1))
    done

    if [ "$count" -eq 0 ]; then
        t trash_empty_msg
        return
    fi

    t trash_list_title "$count" "$TRASH_MAX_ITEMS"

    local now
    now=$(date +%s)
    local dir info name timestamp age_secs remaining age_str expiry_str
    for dir in "$TRASH_DIR"/*/; do
        [ -d "$dir" ] || continue
        info="${dir}.trash_info"
        name=$(basename "$dir")
        if [ -f "$info" ]; then
            timestamp=$(cat "$info")
            age_secs=$((now - timestamp))
            remaining=$((TRASH_MAX_DAYS * 86400 - age_secs))
            if [ "$age_secs" -lt 3600 ]; then
                age_str="$((age_secs / 60))m ago"
            elif [ "$age_secs" -lt 86400 ]; then
                age_str="$((age_secs / 3600))h ago"
            else
                age_str="$((age_secs / 86400))d ago"
            fi
            if [ "$remaining" -lt 3600 ]; then
                expiry_str="$((remaining / 60))m"
            elif [ "$remaining" -lt 86400 ]; then
                expiry_str="$((remaining / 3600))h"
            else
                expiry_str="$((remaining / 86400))d"
            fi
        else
            age_str="?"
            expiry_str="?"
        fi
        printf "  %s  (%s, expires in %s)\n" "$name" "$age_str" "$expiry_str"
    done
}

trash_empty() {
    local count
    count=$(trash_count)

    if [ "$count" -eq 0 ]; then
        t trash_empty_msg
        return
    fi

    t trash_empty_confirm "$count"
    local reply
    read -r reply
    if [[ "$reply" =~ ^[Yy]([Ee][Ss])?$ ]]; then
        rm -rf "${TRASH_DIR:?}"/*/
        t trash_empty_done
    else
        t remove_aborted
    fi
}

trash_remove() {
    local name="$1"
    if [ -z "$name" ]; then
        t trash_remove_usage
        return 1
    fi

    if [ "$name" = "all" ]; then
        trash_empty
        return
    fi

    local path="$TRASH_DIR/$name"
    if [ ! -d "$path" ]; then
        t trash_not_found "$name"
        return 1
    fi

    rm -rf "$path"
    t trash_remove_success "$name"
}

trash_restore() {
    local name="$1"
    if [ -z "$name" ]; then
        t trash_restore_usage
        return 1
    fi

    if [ "$name" = "all" ]; then
        local restored=0
        for dir in "$TRASH_DIR"/*/; do
            [ -d "$dir" ] || continue
            local n
            n=$(basename "$dir")
            rm -f "$dir/.trash_info"
            rm -rf "${PROJECTS_DIR:?}/${n:?}"
            mv "$dir" "$PROJECTS_DIR/$n"
            restored=$((restored + 1))
        done
        if [ "$restored" -eq 0 ]; then
            t trash_empty_msg
        else
            t trash_restore_all_success "$restored"
        fi
        return
    fi

    local path="$TRASH_DIR/$name"
    if [ ! -d "$path" ]; then
        t trash_not_found "$name"
        return 1
    fi

    rm -f "$path/.trash_info"
    rm -rf "${PROJECTS_DIR:?}/${name:?}"
    mv "$path" "$PROJECTS_DIR/$name"
    t trash_restore_success "$name"
}
