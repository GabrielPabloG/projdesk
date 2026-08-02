#!/usr/bin/env bash

PROJDESK_LANG_DIR="${PROJDESK_SRC:-$(dirname "${BASH_SOURCE[0]}")}/lang"

# shellcheck disable=SC1090
for langfile in "$PROJDESK_LANG_DIR"/*.sh; do
    source "$langfile"
done

pd_lang() {
    if [ -n "${PD_LANG:-}" ]; then
        echo "$PD_LANG"
        return
    fi
    case "${LANG:-}" in
        en*) echo "en" ;;
        pt*) echo "pt_BR" ;;
        es*) echo "es" ;;
        *)   echo "en" ;;
    esac
}

t() {
    local key="$1"; shift
    local pd msgvar msg
    pd="$(pd_lang)"
    msgvar="MSG_${pd}_$key"
    msg="${!msgvar:-$key}"
    # shellcheck disable=SC2059
    printf -v msg -- "$msg" "$@"
    printf '%s\n' "$msg"
}
