#!/usr/bin/env bash

# shellcheck source=src/strings.sh
source "$HOME/.config/projdesk/src/strings.sh"

t install_title

INIT_SCRIPT="$HOME/.config/projdesk/src/init.sh"

if ! grep -q "projdesk/src/init.sh" "$HOME/.bashrc"; then
    {
        echo ""
        t install_comment
        echo "source $INIT_SCRIPT"
    } >> "$HOME/.bashrc"
    t install_added
else
    t install_already
fi

t install_done
