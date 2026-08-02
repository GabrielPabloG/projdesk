#!/usr/bin/env bash

docker_running() {

    if [ "$DOCKER_MODE" = "wsl" ]; then

        docker info >/dev/null 2>&1

    else

        powershell.exe -NoProfile \
            -Command "Get-Process 'Docker Desktop' -ErrorAction SilentlyContinue" \
            | grep -q "Docker Desktop"

    fi

}

containers_running() {

    docker info >/dev/null 2>&1 || return 1

    [[ -n "$(docker compose ps -q)" ]]
}

start_docker() {

    if docker_running; then
        return
    fi

    if [ "$DOCKER_MODE" = "wsl" ]; then

        t docker_starting_wsl

        sudo service docker start

    else

        t docker_starting_desktop

        powershell.exe -NoProfile \
            -Command "& '$DOCKER_EXE'"

    fi

    t docker_waiting

    until docker info >/dev/null 2>&1; do
        sleep 2
    done

    t docker_ready
}

compose_command() {

    if [[ -f docker-compose.dev.yml ]]; then

        docker compose \
            -f docker-compose.yml \
            -f docker-compose.dev.yml \
            "$@"

    else

        docker compose "$@"

    fi
}

compose_up() {

    if ! has_docker_compose; then
        t compose_not_found
        return 1
    fi

    start_docker

    compose_command up -d
}

compose_build() {

    if ! has_docker_compose; then
        t compose_not_found
        return 1
    fi

    start_docker

    compose_command up --build -d
}

compose_down() {

    if ! has_docker_compose; then
        t compose_not_found
        return 1
    fi

    compose_command down
}

compose_logs() {

    if ! has_docker_compose; then
        t compose_not_found
        return 1
    fi

    compose_command logs -f
}
