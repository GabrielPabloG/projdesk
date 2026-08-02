#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/detect.sh"

@test "has_docker_compose: returns 0 when docker-compose.yml exists" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.yml
    run has_docker_compose
    [ "$status" -eq 0 ]
}

@test "has_docker_compose: returns 0 when compose.yml exists" {
    cd "$BATS_TEST_TMPDIR"
    touch compose.yml
    run has_docker_compose
    [ "$status" -eq 0 ]
}

@test "has_docker_compose: returns 0 when docker-compose.dev.yml exists" {
    cd "$BATS_TEST_TMPDIR"
    touch docker-compose.dev.yml
    run has_docker_compose
    [ "$status" -eq 0 ]
}

@test "has_docker_compose: returns 1 when no compose file" {
    cd "$BATS_TEST_TMPDIR"
    run has_docker_compose
    [ "$status" -eq 1 ]
}

@test "is_mobile_project: returns 0 when build.gradle exists" {
    cd "$BATS_TEST_TMPDIR"
    touch build.gradle
    run is_mobile_project
    [ "$status" -eq 0 ]
}

@test "is_mobile_project: returns 0 when pubspec.yaml exists" {
    cd "$BATS_TEST_TMPDIR"
    touch pubspec.yaml
    run is_mobile_project
    [ "$status" -eq 0 ]
}

@test "is_mobile_project: returns 1 when none present" {
    cd "$BATS_TEST_TMPDIR"
    run is_mobile_project
    [ "$status" -eq 1 ]
}
