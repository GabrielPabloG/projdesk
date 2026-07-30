#!/usr/bin/env bash

PROJDESK_SRC="$HOME/.config/projdesk/src"

source "$PROJDESK_SRC/config.sh"
source "$PROJDESK_SRC/detect.sh"
source "$PROJDESK_SRC/docker.sh"
source "$PROJDESK_SRC/project.sh"
source "$PROJDESK_SRC/completion.sh"

pd() {
    main "$@"
}
