#!/usr/bin/env bash

# Nova função para listar os projetos
list_projects() {
    if [ ! -d "$PROJECTS_DIR" ]; then
        t projects_dir_not_found "$PROJECTS_DIR"
        return 1
    fi

    t projects_title
    ls -1 "$PROJECTS_DIR"
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

    mkdir -p "$PROJECTS_DIR/$PROJECT"
    cd "$PROJECTS_DIR/$PROJECT" || return 1

    recent_add "$PROJECT"

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
        *)
            open_project "$1"
            ;;
    esac
}
