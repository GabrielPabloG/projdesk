#!/usr/bin/env bash

_pd_commands() {
    echo "a down h help l lang list logs ls r recent rebuild remove rm resolve t trash up"
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
        resolve|remove|rm)
            local proj_words
            proj_words+="all"
            for dir in "$PROJECTS_DIR"/*; do
                [[ -d "$dir" ]] || continue
                proj_words+=" $(basename "$dir")"
            done
            mapfile -t COMPREPLY < <(compgen -W "$proj_words" -- "$current")
            ;;
        trash|t)
            mapfile -t COMPREPLY < <(compgen -W "list ls empty remove rm restore" -- "$current")
            ;;
    esac

    local pprev
    pprev="${COMP_WORDS[COMP_CWORD-2]}"

    case "$prev" in
        remove|rm)
            if [ "$pprev" = "trash" ] || [ "$pprev" = "t" ]; then
                local trash_words
                trash_words+="all"
                for dir in "$TRASH_DIR"/*/; do
                    [[ -d "$dir" ]] || continue
                    trash_words+=" $(basename "$dir")"
                done
                mapfile -t COMPREPLY < <(compgen -W "$trash_words" -- "$current")
            fi
            ;;
        restore)
            if [ "$pprev" = "trash" ] || [ "$pprev" = "t" ]; then
                local trash_words
                trash_words+="all"
                for dir in "$TRASH_DIR"/*/; do
                    [[ -d "$dir" ]] || continue
                    trash_words+=" $(basename "$dir")"
                done
                mapfile -t COMPREPLY < <(compgen -W "$trash_words" -- "$current")
            fi
            ;;
    esac

}

complete -F _pd_completion pd projdesk
