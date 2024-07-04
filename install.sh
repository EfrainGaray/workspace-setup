#!/bin/bash

# Paquetes requeridos
REQUIRED_PACKAGES=("i3" "kitty" "feh" "git" "vim" "unzip" "curl" "picom" "fzf" "lsd")

# Comprobar si los paquetes requeridos están instalados y, si no, instalarlos
missing_packages=()
for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! command -v $package &> /dev/null; then
        missing_packages+=($package)
    fi
done

if [ ${#missing_packages[@]} -ne 0 ]; then
    echo "Los siguientes paquetes están ausentes: ${missing_packages[@]}"
    echo "Instalándolos ahora..."
    sudo dnf install -y ${missing_packages[@]}
fi

# Mostrar advertencia al usuario
echo "Este script sobrescribirá su configuración de i3, Kitty y Picom."
read -p "¿Desea continuar? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    exit 1
fi

# Crear directorios de configuración si no existen
mkdir -p ~/.config/i3
mkdir -p ~/.config/kitty
mkdir -p ~/.config/picom

# Sobrescribir configuraciones de i3
cp i3/config ~/.config/i3/config

# Sobrescribir configuraciones de Kitty
cp kitty/kitty.conf ~/.config/kitty/kitty.conf

# Sobrescribir configuraciones de Picom
cp picom/picom.conf ~/.config/picom/picom.conf

# Instalar Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d FiraCode
rm FiraCode.zip

# Actualizar caché de fuentes
fc-cache -fv

# Añadir picom al inicio automático de i3
if ! grep -q "exec --no-startup-id picom" ~/.config/i3/config; then
    echo "exec --no-startup-id picom" >> ~/.config/i3/config
fi

# Clonar el repositorio de temas de Kitty
cd ~
if [ ! -d "kitty-themes" ]; then
    git clone https://github.com/dexpota/kitty-themes.git
else
    cd kitty-themes
    git pull
    cd ..
fi

# Listar temas disponibles
echo "Selecciona un tema de la lista usando las teclas de navegación y presiona Enter para aplicar:"
theme_name=$(ls kitty-themes/themes/ | fzf)

# Verificar si el tema existe y aplicarlo
if [ -f "kitty-themes/themes/$theme_name" ]; then
    echo "include ~/kitty-themes/themes/$theme_name" >> ~/.config/kitty/kitty.conf
    echo "Tema $theme_name aplicado a Kitty."
else
    echo "El tema $theme_name no existe. No se aplicaron cambios en el tema."
fi

# Configurar alias para lsd
if ! grep -q "alias ls=" ~/.bashrc; then
    echo 'alias ls="lsd"' >> ~/.bashrc
    echo 'alias ll="lsd -l"' >> ~/.bashrc
    echo 'alias la="lsd -a"' >> ~/.bashrc
    echo 'alias lla="lsd -la"' >> ~/.bashrc
fi

echo "Configuraciones de i3, Kitty y Picom instaladas correctamente, y Nerd Font configurada. Alias para lsd configurados."

cd -

