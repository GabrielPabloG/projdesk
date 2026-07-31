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

open_project() {
    local PROJECT="$1"
    local FORCE_ANDROID="$2" 

    if [ -z "$PROJECT" ]; then
        echo "Uso: pd [a] <projeto>"
        return 1
    fi

    mkdir -p "$PROJECTS_DIR/$PROJECT"
    cd "$PROJECTS_DIR/$PROJECT" || return 1

    if has_docker_compose; then
        start_docker
        if [ "$AUTO_START_CONTAINERS" = true ]; then
            compose_up
        fi
    fi

    if [ "$AUTO_OPEN_CODE" = true ]; then
        if [ "$FORCE_ANDROID" = true ] || is_mobile_project; then
            echo "📱 Projeto Mobile detectado! Abrindo no Android Studio..."
            ~/android-studio/bin/studio.sh . &
        else
            echo "💻 Abrindo no VS Code..."
            code .
        fi
    fi
}

main() {
    local FORCE_ANDROID=false

    if [[ "$1" == "a" || "$1" == "-a" || "$1" == "--android" ]]; then
        FORCE_ANDROID=true
        shift 
    fi

    case "$1" in
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
        *)
            open_project "$1" "$FORCE_ANDROID"
            ;;
    esac
}
