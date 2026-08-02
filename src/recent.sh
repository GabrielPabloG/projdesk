#!/usr/bin/env bash

recent_file() {
    echo "$RECENT_FILE"
}

recent_add() {
    local PROJECT="$1"

    [ -z "$PROJECT" ] && return 1

    local FILE
    FILE="$(recent_file)"

    mkdir -p "$(dirname "$FILE")"

    local TMP
    TMP="$(mktemp)"

    if [ -f "$FILE" ]; then
        grep -v "^$PROJECT$" "$FILE" > "$TMP" || true
    else
        : > "$TMP"
    fi

    {
        echo "$PROJECT"
        cat "$TMP"
    } > "$FILE"

    head -n 20 "$FILE" > "$TMP"
    mv "$TMP" "$FILE"
}

recent_list() {
    local FILE
    FILE="$(recent_file)"

    if [ ! -s "$FILE" ]; then
        echo "🕐 Nenhum projeto recente ainda."
        return 1
    fi

    echo "🕐 Projetos recentes:"
    head -n 10 "$FILE" | nl -w 2 -s '. '
}

recent_open() {
    local FILE
    FILE="$(recent_file)"

    local LATEST
    LATEST="$(head -n 1 "$FILE" 2>/dev/null)"

    if [ -z "$LATEST" ]; then
        echo "🕐 Nenhum projeto recente ainda. Abra um com: pd <projeto>"
        return 1
    fi

    open_project "$LATEST"
}

recent() {
    case "$1" in
        list|ls)
            recent_list
            ;;
        *)
            recent_open
            ;;
    esac
}
