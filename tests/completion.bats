#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/completion.sh"

@test "_pd_commands: lists all commands" {
    run _pd_commands
    [[ "$output" == *"a "* ]]
    [[ "$output" == *" down "* ]]
    [[ "$output" == *" list "* ]]
    [[ "$output" == *" rebuild "* ]]
    [[ "$output" == *" up"* ]]
}

@test "_pd_completion: completes partial command 'li' to list" {
    COMP_WORDS=("pd" "li")
    COMP_CWORD=1
    _pd_completion
    [[ "${COMPREPLY[*]}" == *"list"* ]]
}

@test "_pd_completion: completes project names" {
    mkdir -p "$PROJECTS_DIR/fooapp" "$PROJECTS_DIR/barapp"
    COMP_WORDS=("pd" "fo")
    COMP_CWORD=1
    _pd_completion
    [[ "${COMPREPLY[*]}" == *"fooapp"* ]]
    [[ "${COMPREPLY[*]}" != *"barapp"* ]]
}

@test "_pd_completion: recent subcommand completes with list" {
    COMP_WORDS=("pd" "recent" "li")
    COMP_CWORD=2
    _pd_completion
    [[ "${COMPREPLY[*]}" == *"list"* ]]
}

@test "_pd_completion: r alias subcommand completes with list" {
    COMP_WORDS=("pd" "r" "li")
    COMP_CWORD=2
    _pd_completion
    [[ "${COMPREPLY[*]}" == *"list"* ]]
}
