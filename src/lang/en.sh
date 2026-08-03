#!/usr/bin/env bash

declare -A MSG=(
    [install_title]="🚀 Installing ProjDesk..."
    [install_comment]="# Initializes ProjDesk"
    [install_added]="✅ ProjDesk added to your ~/.bashrc!"
    [install_already]="⚠️ ProjDesk is already configured in your ~/.bashrc."
    [install_done]="🎉 Installation complete! Restart your terminal or run: source ~/.bashrc"
    [projects_dir_not_found]="❌ Project directory not found: %s"
    [projects_title]="📂 Your projects:"
    [android_opening]="📱 Opening Android Studio..."
    [usage_open]="Usage: pd <project>"
    [mobile_detected]="📱 Mobile project detected! Opening Android Studio..."
    [vscode_opening]="💻 Opening VS Code..."
    [docker_starting_wsl]="🐳 Starting Docker (WSL)..."
    [docker_starting_desktop]="🐳 Starting Docker Desktop..."
    [docker_waiting]="⌛ Waiting for Docker..."
    [docker_ready]="✅ Docker ready"
    [compose_not_found]="❌ docker-compose.yml not found."
    [recent_empty]="🕐 No recent projects yet."
    [recent_title]="🕐 Recent projects:"
    [recent_empty_open]="🕐 No recent projects yet. Open one with: pd <project>"
    [help_title]="ProjDesk — Less friction. More code."
    [help_tip]="💡 Set PD_LANG=en, pt_BR, or es in config.sh."
    [lang_current]="Language: %s"
    [lang_switched]="Switched to %s."
    [resolve_ambiguous]="Multiple projects match \"%s\". Be more specific."
)

for key in "${!MSG[@]}"; do
    export "MSG_en_$key=${MSG[$key]}"
done
unset MSG
