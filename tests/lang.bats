#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/detect.sh"
source "$SRC/docker.sh"
source "$SRC/recent.sh"
source "$SRC/project.sh"

@test "main lang en switches to English" {
    export PD_LANG=pt_BR
    run main lang en
    [[ "$output" == *"Switched to en"* ]]
}

@test "main l en switches to English" {
    export PD_LANG=pt_BR
    run main l en
    [[ "$output" == *"Switched to en"* ]]
}

@test "main lang pt switches to pt_BR" {
    export PD_LANG=en
    run main lang pt
    [[ "$output" == *"Alterado para pt_BR"* ]]
}

@test "main lang es switches to Spanish" {
    export PD_LANG=pt_BR
    run main lang es
    [[ "$output" == *"Cambiado a es"* ]]
}

@test "main lang (no arg) shows current language" {
    export PD_LANG=en
    run main lang
    [[ "$output" == *"Language"* ]]
    [[ "$output" == *"en"* ]]
}
