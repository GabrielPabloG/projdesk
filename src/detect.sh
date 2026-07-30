#!/usr/bin/env bash

has_docker_compose() {

    local files=(
        docker-compose.yml
        docker-compose.yaml
        compose.yml
        compose.yaml
        docker-compose.dev.yml
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            return 0
        fi
    done

    return 1
}

is_mobile_project() {
    # Verifica se existe configuração do Gradle (Android nativo) ou Flutter
    if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ] || [ -f "settings.gradle" ] || [ -f "pubspec.yaml" ]; then
        return 0
    fi
    return 1
}
