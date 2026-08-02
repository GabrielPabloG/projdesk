#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/recent.sh"

@test "recent_add: creates file with project at top" {
    run recent_add "myapp"
    [ "$status" -eq 0 ]
    [ -f "$RECENT_FILE" ]
    [ "$(head -n 1 "$RECENT_FILE")" = "myapp" ]
}

@test "recent_add: dedupes existing entry" {
    recent_add "myapp"
    recent_add "myapp"
    [ "$(grep -c "^myapp$" "$RECENT_FILE")" -eq 1 ]
}

@test "recent_add: caps at 20 lines" {
    for i in $(seq 1 25); do
        recent_add "project-$i"
    done
    [ "$(wc -l < "$RECENT_FILE")" -le 20 ]
}

@test "recent_add: empty arg returns 1" {
    run recent_add ""
    [ "$status" -eq 1 ]
}

@test "recent_list: shows message when file is empty" {
    run recent_list
    [ "$status" -eq 1 ]
    [[ "$output" == *"Nenhum projeto recente"* ]]
}

@test "recent_list: lists entries with line numbers" {
    recent_add "alpha"
    recent_add "beta"
    run recent_list
    [ "$status" -eq 0 ]
    [[ "$output" == *"alpha"* ]]
    [[ "$output" == *"beta"* ]]
}

@test "recent_open: empty file returns 1" {
    run recent_open
    [ "$status" -eq 1 ]
}

@test "recent_open: calls open_project with latest" {
    recent_add "latest-project"
    open_project() { echo "open:$1"; }
    run recent_open
    [ "$status" -eq 0 ]
    [[ "$output" == *"open:latest-project"* ]]
}

@test "recent router: calls recent_open by default" {
    recent_add "demo"
    open_project() { echo "open:$1"; }
    run recent
    [ "$status" -eq 0 ]
    [[ "$output" == *"open:demo"* ]]
}

@test "recent router: calls recent_list with list arg" {
    run recent list
    [ "$status" -eq 1 ]
    [[ "$output" == *"Nenhum projeto recente"* ]]
}
