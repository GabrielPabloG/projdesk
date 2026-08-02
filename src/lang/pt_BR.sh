#!/usr/bin/env bash

declare -A MSG=(
    [install_title]="🚀 Instalando o ProjDesk..."
    [install_comment]="# Inicializa o ProjDesk"
    [install_added]="✅ ProjDesk adicionado ao seu ~/.bashrc!"
    [install_already]="⚠️ ProjDesk já está configurado no seu ~/.bashrc."
    [install_done]="🎉 Instalação concluída! Reinicie o terminal ou rode: source ~/.bashrc"
    [projects_dir_not_found]="❌ Diretório de projetos não encontrado: %s"
    [projects_title]="📂 Seus projetos:"
    [android_opening]="📱 Abrindo Android Studio..."
    [usage_open]="Uso: pd <projeto>"
    [mobile_detected]="📱 Projeto Mobile detectado! Abrindo no Android Studio..."
    [vscode_opening]="💻 Abrindo no VS Code..."
    [docker_starting_wsl]="🐳 Iniciando Docker (WSL)..."
    [docker_starting_desktop]="🐳 Iniciando Docker Desktop..."
    [docker_waiting]="⌛ Aguardando Docker..."
    [docker_ready]="✅ Docker pronto"
    [compose_not_found]="❌ docker-compose.yml não encontrado."
    [recent_empty]="🕐 Nenhum projeto recente ainda."
    [recent_title]="🕐 Projetos recentes:"
    [recent_empty_open]="🕐 Nenhum projeto recente ainda. Abra um com: pd <projeto>"
    [help_title]="ProjDesk — Menos fricção. Mais código."
    [help_tip]="💡 Defina PD_LANG=en, pt_BR ou es no config.sh."
    [lang_current]="Idioma atual: %s"
    [lang_switched]="Alterado para %s."
)

for key in "${!MSG[@]}"; do
    export "MSG_pt_BR_$key=${MSG[$key]}"
done
unset MSG
