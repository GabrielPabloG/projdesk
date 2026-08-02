#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/detect.sh"
source "$SRC/docker.sh"

stub_docker() {
    cat > "$BATS_TEST_TMPDIR/bin/docker" <<'SCRIPT'
#!/usr/bin/env bash
echo "docker:$*" >> "$MOCK_LOG"
exit 0
SCRIPT
    chmod +x "$BATS_TEST_TMPDIR/bin/docker"
}

@test "docker_running: returns 0 when docker info succeeds (wsl)" {
    stub_docker
    run docker_running
    [ "$status" -eq 0 ]
}

@test "docker_running: returns 1 when docker info fails (wsl)" {
    cat > "$BATS_TEST_TMPDIR/bin/docker" <<'SCRIPT'
#!/usr/bin/env bash
exit 1
SCRIPT
    chmod +x "$BATS_TEST_TMPDIR/bin/docker"
    run docker_running
    [ "$status" -eq 1 ]
}

@test "start_docker: returns immediately when already running" {
    stub_docker
    mock_cmd sudo "SUDO"
    start_docker
    ! grep -q "SUDO" "$MOCK_LOG"
}

@test "compose_up: fails when no compose file" {
    cd "$BATS_TEST_TMPDIR"
    run compose_up
    [ "$status" -eq 1 ]
    [[ "$output" == *"não encontrado"* ]]
}

@test "compose_up: runs docker compose up -d" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml
    stub_docker
    start_docker() { :; }
    run compose_up
    grep -q "docker:compose up -d" "$MOCK_LOG"
}

@test "compose_down: runs docker compose down" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml
    stub_docker
    run compose_down
    grep -q "docker:compose down" "$MOCK_LOG"
}

@test "compose_build: runs docker compose up --build -d" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml
    stub_docker
    start_docker() { :; }
    run compose_build
    grep -q "docker:compose up --build -d" "$MOCK_LOG"
}

@test "compose_logs: runs docker compose logs -f" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml
    stub_docker
    run compose_logs
    grep -q "docker:compose logs -f" "$MOCK_LOG"
}

@test "compose_command: includes dev override when docker-compose.dev.yml exists" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml docker-compose.dev.yml
    stub_docker
    run compose_command up -d
    grep -q "docker:compose -f docker-compose.yml -f docker-compose.dev.yml up -d" "$MOCK_LOG"
}

@test "compose_command: no dev override without docker-compose.dev.yml" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml
    stub_docker
    run compose_command up -d
    grep -q "docker:compose up -d" "$MOCK_LOG"
}
