#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers

@test "install.sh: adds source line to .bashrc" {
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME/.config/projdesk/src"
    touch "$HOME/.bashrc"
    touch "$HOME/.config/projdesk/src/init.sh"
    run bash "$TEST_ROOT/../install.sh"
    grep -q "projdesk/src/init.sh" "$HOME/.bashrc"
}

@test "install.sh: idempotent (no duplicate)" {
    export HOME="$BATS_TEST_TMPDIR/home2"
    mkdir -p "$HOME/.config/projdesk/src"
    touch "$HOME/.bashrc"
    touch "$HOME/.config/projdesk/src/init.sh"
    run bash "$TEST_ROOT/../install.sh"
    run bash "$TEST_ROOT/../install.sh"
    [ "$(grep -c "projdesk/src/init.sh" "$HOME/.bashrc")" -eq 1 ]
}
