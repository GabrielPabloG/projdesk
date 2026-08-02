#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v bats &>/dev/null; then
    BATS_BIN=bats
else
    CACHE="$HOME/.cache/projdesk/bats-core"
    BATS_BIN="$CACHE/bin/bats"
    if [ ! -x "$BATS_BIN" ]; then
        echo "Bootstrapping bats-core -> $CACHE ..."
        mkdir -p "$(dirname "$CACHE")"
        git clone --depth 1 https://github.com/bats-core/bats-core.git "$CACHE"
    fi
fi

exec "$BATS_BIN" "$ROOT/tests"
