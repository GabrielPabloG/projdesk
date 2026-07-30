#!/usr/bin/env bash

_pd_completion() {

    local current

    current="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=()

    local projects=()

    for dir in "$PROJECTS_DIR"/*; do

        [[ -d "$dir" ]] || continue

        projects+=("$(basename "$dir")")

    done

    COMPREPLY=(
        $(compgen -W "${projects[*]}" -- "$current")
    )

}

complete -F _pd_completion pd
