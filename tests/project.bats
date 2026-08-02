#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/detect.sh"
source "$SRC/docker.sh"
source "$SRC/recent.sh"
source "$SRC/project.sh"

stub_docker_ok() {
    cat > "$BATS_TEST_TMPDIR/bin/docker" <<'SCRIPT'
#!/usr/bin/env bash
echo "docker:$*" >> "$MOCK_LOG"
exit 0
SCRIPT
    chmod +x "$BATS_TEST_TMPDIR/bin/docker"
}

stub_docker_fail() {
    cat > "$BATS_TEST_TMPDIR/bin/docker" <<'SCRIPT'
#!/usr/bin/env bash
exit 1
SCRIPT
    chmod +x "$BATS_TEST_TMPDIR/bin/docker"
}

@test "list_projects: shows projects" {
    mkdir -p "$PROJECTS_DIR/app1" "$PROJECTS_DIR/app2"
    run list_projects
    [ "$status" -eq 0 ]
    [[ "$output" == *"app1"* ]]
    [[ "$output" == *"app2"* ]]
}

@test "list_projects: fails when PROJECTS_DIR missing" {
    PROJECTS_DIR="/nonexistent-dir"
    run list_projects
    [ "$status" -eq 1 ]
    [[ "$output" == *"não encontrado"* ]]
}

@test "open_project: no argument returns 1" {
    run open_project ""
    [ "$status" -eq 1 ]
    [[ "$output" == *"Uso"* ]]
}

@test "open_project: creates dir, adds to recent" {
    mock_cmd code "CODE"
    run open_project "foobar"
    [ -d "$PROJECTS_DIR/foobar" ]
    [ "$(head -n 1 "$RECENT_FILE")" = "foobar" ]
}

@test "open_project: opens VS Code by default" {
    mock_cmd code "CODE"
    run open_project "foobar"
    grep -q "CODE" "$MOCK_LOG"
}

@test "open_project: opens Android Studio for mobile project" {
    mock_cmd code "CODE"
    mkdir -p "$PROJECTS_DIR/mobileapp"
    touch "$PROJECTS_DIR/mobileapp/build.gradle"
    run open_project "mobileapp"
    [[ "$output" == *"Projeto Mobile detectado"* ]]
}

@test "open_project: AUTO_OPEN_CODE=false does not open IDE" {
    mock_cmd code "CODE"
    AUTO_OPEN_CODE=false
    run open_project "noide"
    ! grep -q "CODE" "$MOCK_LOG"
}

@test "open_project: AUTO_START_CONTAINERS=true calls compose_up" {
    mkdir -p "$PROJECTS_DIR/composepro"
    touch "$PROJECTS_DIR/composepro/docker-compose.yml"
    stub_docker_ok
    start_docker() { :; }
    compose_up() { echo "compose_up called"; }
    AUTO_START_CONTAINERS=true
    run open_project "composepro"
    [[ "$output" == *"compose_up called"* ]]
}

@test "open_android_studio: prints message" {
    run open_android_studio
    [[ "$output" == *"Abrindo Android Studio"* ]]
}

@test "main: routes a / -a / --android to open_android_studio" {
    run main a
    [[ "$output" == *"Abrindo Android Studio"* ]]
    run main -a
    [[ "$output" == *"Abrindo Android Studio"* ]]
    run main --android
    [[ "$output" == *"Abrindo Android Studio"* ]]
}

@test "main: routes list / ls to list_projects" {
    run main list
    [[ "$output" == *"Seus projetos"* ]]
    run main ls
    [[ "$output" == *"Seus projetos"* ]]
}

@test "main: routes up to compose_up" {
    compose_up() { echo "_compose_up_"; }
    run main up
    [[ "$output" == *"_compose_up_"* ]]
}

@test "main: routes down to compose_down" {
    compose_down() { echo "_compose_down_"; }
    run main down
    [[ "$output" == *"_compose_down_"* ]]
}

@test "main: routes rebuild to compose_build" {
    compose_build() { echo "_compose_build_"; }
    run main rebuild
    [[ "$output" == *"_compose_build_"* ]]
}

@test "main: routes logs to compose_logs" {
    compose_logs() { echo "_compose_logs_"; }
    run main logs
    [[ "$output" == *"_compose_logs_"* ]]
}

@test "main: routes recent / r" {
    recent() { echo "_recent_ $*"; }
    run main recent
    [[ "$output" == *"_recent_"* ]]
    run main r
    [[ "$output" == *"_recent_"* ]]
}

@test "main: falls through to open_project" {
    mock_cmd code "CODE"
    run main "newapp"
    [ -d "$PROJECTS_DIR/newapp" ]
}
