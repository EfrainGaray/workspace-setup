#!/bin/bash

# Paquetes requeridos
REQUIRED_PACKAGES=("i3" "kitty" "feh" "git" "vim" "unzip" "curl")

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
echo "Este script sobrescribirá su configuración de i3 y Kitty."
read -p "¿Desea continuar? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operación cancelada."
    exit 1
fi

# Crear directorios de configuración si no existen
mkdir -p ~/.config/i3
mkdir -p ~/.config/kitty

# Copiar configuraciones de i3 solo si no existen
if [ ! -f ~/.config/i3/config ]; then
    cp -r i3/config ~/.config/i3/config
fi

# Copiar configuraciones de Kitty solo si no existen
if [ ! -f ~/.config/kitty/kitty.conf ]; then
    cp -r kitty/kitty.conf ~/.config/kitty/kitty.conf
fi

# Instalar Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d FiraCode
rm FiraCode.zip

# Actualizar caché de fuentes
fc-cache -fv

echo "Configuraciones de i3 y Kitty instaladas correctamente, y Nerd Font configurada."

cd -

