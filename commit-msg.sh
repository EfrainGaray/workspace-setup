#!/bin/bash

# Reglas de commitlint
RULES="^(feat|fix|docs|style|refactor|perf|test|chore)(\(\w+\))?: .{1,50}$"

# Leer el mensaje de commit
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat $COMMIT_MSG_FILE)

if [[ ! $COMMIT_MSG =~ $RULES ]]; then
  echo "ERROR: El mensaje de commit no sigue las convenciones."
  echo "Ejemplo: feat(scope): agregar nueva característica"
  exit 1
fi

