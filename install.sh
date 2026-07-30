#!/usr/bin/env bash

echo "🚀 Instalando o ProjDesk..."

INIT_SCRIPT="$HOME/.config/projdesk/src/init.sh"

# Verifica se já existe no bashrc para não duplicar
if ! grep -q "projdesk/src/init.sh" "$HOME/.bashrc"; then
    echo "" >> "$HOME/.bashrc"
    echo "# Inicializa o ProjDesk" >> "$HOME/.bashrc"
    echo "source $INIT_SCRIPT" >> "$HOME/.bashrc"
    echo "✅ ProjDesk adicionado ao seu ~/.bashrc!"
else
    echo "⚠️ ProjDesk já está configurado no seu ~/.bashrc."
fi

echo "🎉 Instalação concluída! Reinicie o terminal ou rode: source ~/.bashrc"
