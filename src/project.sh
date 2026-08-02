#!/usr/bin/env bash

# Nova função para listar os projetos
list_projects() {
    # Verifica se a pasta base de projetos existe
    if [ ! -d "$PROJECTS_DIR" ]; then
        echo "❌ Diretório de projetos não encontrado: $PROJECTS_DIR"
        return 1
    fi

    echo "📂 Seus projetos:"
    # Lista apenas os nomes das pastas dentro do diretório, em ordem alfabética
    ls -1 "$PROJECTS_DIR"
}

open_android_studio() {
    echo "📱 Abrindo Android Studio..."
    ~/android-studio/bin/studio.sh &
}

open_project() {
    local PROJECT="$1"

    if [ -z "$PROJECT" ]; then
        echo "Uso: pd <projeto>"
        return 1
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
            echo "📱 Projeto Mobile detectado! Abrindo no Android Studio..."
            ~/android-studio/bin/studio.sh . &
        else
            echo "💻 Abrindo no VS Code..."
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
