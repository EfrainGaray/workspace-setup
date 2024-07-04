#!/bin/bash

# Paquetes requeridos
REQUIRED_PACKAGES=("i3" "kitty" "feh" "git" "vim")

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

# Copiar configuraciones de i3
cp -r i3 ~/.config/i3

# Copiar configuraciones de Kitty
cp -r kitty ~/.config/kitty

echo "Configuraciones de i3 y Kitty instaladas correctamente."

