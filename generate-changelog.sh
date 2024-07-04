#!/bin/bash

# Comprobar si el archivo CHANGELOG.md existe, si no, crearlo
if [ ! -f CHANGELOG.md ]; then
  touch CHANGELOG.md
fi

# Generar el changelog usando git log
echo "# Changelog" > CHANGELOG.md
git log --pretty=format:"%h - %s (%an, %ad)" --date=short --abbrev-commit >> CHANGELOG.md

echo "Changelog generado correctamente."

