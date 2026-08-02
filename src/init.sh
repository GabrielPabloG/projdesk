#!/usr/bin/env bash

# shellcheck source=config.example.sh
# shellcheck source=detect.sh
# shellcheck source=docker.sh
# shellcheck source=recent.sh
# shellcheck source=project.sh
# shellcheck source=completion.sh
PROJDESK_SRC="$HOME/.config/projdesk/src"

source "$PROJDESK_SRC/config.sh"
source "$PROJDESK_SRC/detect.sh"
source "$PROJDESK_SRC/docker.sh"
source "$PROJDESK_SRC/recent.sh"
source "$PROJDESK_SRC/project.sh"
source "$PROJDESK_SRC/completion.sh"

pd() {
    main "$@"
}

projdesk() {
    main "$@"
}
