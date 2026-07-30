#!/usr/bin/env bash

source "$HOME/.config/projdesk/config.sh"
source "$HOME/.config/projdesk/detect.sh"
source "$HOME/.config/projdesk/docker.sh"
source "$HOME/.config/projdesk/project.sh"
source "$HOME/.config/projdesk/completion.sh"

pd() {
    main "$@"
}
