#!/usr/bin/env bash

_pd_commands() {
    echo "a down h help l lang list logs ls r recent rebuild resolve up"
}

_pd_completion() {

    local current prev

    current="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=()

    if [ "$COMP_CWORD" -eq 1 ]; then

        local words
        words="$(_pd_commands)"

        for dir in "$PROJECTS_DIR"/*; do

            [[ -d "$dir" ]] || continue

            words+=" $(basename "$dir")"

        done

        mapfile -t COMPREPLY < <(compgen -W "$words" -- "$current")

        return
    fi

    case "$prev" in
        recent|r)
            mapfile -t COMPREPLY < <(compgen -W "list ls" -- "$current")
            ;;
        resolve)
            local proj_words
            for dir in "$PROJECTS_DIR"/*; do
                [[ -d "$dir" ]] || continue
                proj_words+=" $(basename "$dir")"
            done
            mapfile -t COMPREPLY < <(compgen -W "$proj_words" -- "$current")
            ;;
    esac

}

complete -F _pd_completion pd projdesk
