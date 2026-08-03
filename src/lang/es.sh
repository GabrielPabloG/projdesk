#!/usr/bin/env bash

declare -A MSG=(
    [install_title]="🚀 Instalando ProjDesk..."
    [install_comment]="# Inicializa ProjDesk"
    [install_added]="✅ ProjDesk agregado a tu ~/.bashrc!"
    [install_already]="⚠️ ProjDesk ya está configurado en tu ~/.bashrc."
    [install_done]="🎉 Instalación completa! Reinicia el terminal o ejecuta: source ~/.bashrc"
    [projects_dir_not_found]="❌ Directorio de proyectos no encontrado: %s"
    [projects_title]="📂 Tus proyectos:"
    [android_opening]="📱 Abriendo Android Studio..."
    [usage_open]="Uso: pd <proyecto>"
    [mobile_detected]="📱 Proyecto Mobile detectado! Abriendo Android Studio..."
    [vscode_opening]="💻 Abriendo VS Code..."
    [docker_starting_wsl]="🐳 Iniciando Docker (WSL)..."
    [docker_starting_desktop]="🐳 Iniciando Docker Desktop..."
    [docker_waiting]="⌛ Esperando Docker..."
    [docker_ready]="✅ Docker listo"
    [compose_not_found]="❌ docker-compose.yml no encontrado."
    [recent_empty]="🕐 No hay proyectos recientes aún."
    [recent_title]="🕐 Proyectos recientes:"
    [recent_empty_open]="🕐 No hay proyectos recientes aún. Abre uno con: pd <proyecto>"
    [help_title]="ProjDesk — Menos fricción. Más código."
    [help_tip]="💡 Configura PD_LANG=en, pt_BR o es en config.sh."
    [lang_current]="Idioma actual: %s"
    [lang_switched]="Cambiado a %s."
    [resolve_ambiguous]="Múltiples proyectos coinciden con \"%s\". Sé más específico."
)

for key in "${!MSG[@]}"; do
    export "MSG_es_$key=${MSG[$key]}"
done
unset MSG
