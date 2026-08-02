#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/detect.sh"
source "$SRC/docker.sh"
source "$SRC/recent.sh"
source "$SRC/project.sh"
source "$SRC/help.sh"

@test "main h shows help" {
    run main h
    [ "$status" -eq 0 ]
    [[ "$output" == *"ProjDesk"* ]]
    [[ "$output" == *"pd <project>"* ]]
    [[ "$output" == *"pd up"* ]]
    [[ "$output" == *"pd help"* ]]
    [[ "$output" == *"pd recent"* ]]
    [[ "$output" == *"pd projdesk"* ]]
}

@test "main help shows help" {
    run main help
    [ "$status" -eq 0 ]
    [[ "$output" == *"ProjDesk"* ]]
    [[ "$output" == *"pd logs"* ]]
}
