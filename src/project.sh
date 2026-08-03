#!/usr/bin/env bash

list_projects() {
    if [ ! -d "$PROJECTS_DIR" ]; then
        t projects_dir_not_found "$PROJECTS_DIR"
        return 1
    fi

    t projects_title
    ls -1 "$PROJECTS_DIR"
}

resolve_project() {
    local PROJECT="$1"

    if [ -z "$PROJECT" ]; then
        printf 'Usage: pd resolve <project>\n' >&2
        return 1
    fi

    if [ -d "$PROJECTS_DIR/$PROJECT" ]; then
        printf '%s\n' "$PROJECTS_DIR/$PROJECT"
        return 0
    fi

    local matches=()
    local dir name
    for dir in "$PROJECTS_DIR"/*; do
        [ -d "$dir" ] || continue
        name="$(basename "$dir")"
        [[ "$name" == "$PROJECT"* ]] && matches+=("$name")
    done

    case "${#matches[@]}" in
        0)
            printf 'Project "%s" not found.\n' "$PROJECT" >&2
            return 1
            ;;
        1)
            printf '%s\n' "$PROJECTS_DIR/${matches[0]}"
            return 0
            ;;
        *)
            printf 'Multiple projects match "%s".\n' "$PROJECT" >&2
            return 2
            ;;
    esac
}

open_android_studio() {
    t android_opening
    ~/android-studio/bin/studio.sh &
}

open_project() {
    local PROJECT="$1"

    if [ -z "$PROJECT" ]; then
        t usage_open
        return 1
    fi

    if [ "$PROJECT" = "projdesk" ]; then
        cd "$HOME/.config/projdesk" || return 1
        recent_add "projdesk"
        if [ "$AUTO_OPEN_CODE" = true ]; then
            t vscode_opening
            code .
        fi
        return
    fi

    local RESOLVED rc
    RESOLVED="$(resolve_project "$PROJECT" 2>/dev/null)"
    rc=$?

    case "$rc" in
        0)
            cd "$RESOLVED" || return 1
            recent_add "$(basename "$RESOLVED")"
            ;;
        1)
            mkdir -p "$PROJECTS_DIR/$PROJECT"
            cd "$PROJECTS_DIR/$PROJECT" || return 1
            recent_add "$PROJECT"
            ;;
        2)
            t resolve_ambiguous "$PROJECT"
            return 2
            ;;
    esac

    if has_docker_compose; then
        start_docker
        if [ "$AUTO_START_CONTAINERS" = true ]; then
            compose_up
        fi
    fi

    if [ "$AUTO_OPEN_CODE" = true ]; then
        if is_mobile_project; then
            t mobile_detected
            ~/android-studio/bin/studio.sh . &
        else
            t vscode_opening
            code .
        fi
    fi
}

main() {
    case "$1" in
        a|-a|--android)
            open_android_studio
            ;;
        up)
            compose_up
            ;;
        rebuild)
            compose_build
            ;;
        down)
            compose_down
            ;;
        logs)
            compose_logs
            ;;
        list|ls)
            list_projects
            ;;
        recent|r)
            shift
            recent "$@"
            ;;
        remove|rm)
            shift
            remove_project "$@"
            ;;
        trash|t)
            shift
            trash "$@"
            ;;
        help|h)
            show_help
            ;;
        resolve)
            shift
            resolve_project "$1"
            ;;
        lang|l)
            shift
            cmd_lang "$@"
            ;;
        *)
            open_project "$1"
            ;;
    esac
}
