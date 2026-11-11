#!/usr/bin/env bash
# Funciones y configuración compartidas por todos los scripts.
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$RAIZ/lab.env"

VERDE='\033[0;32m'; AMARILLO='\033[1;33m'; ROJO='\033[0;31m'; AZUL='\033[1;34m'; NC='\033[0m'

titulo() { echo -e "\n${AZUL}══════ $* ══════${NC}"; }
paso()   { echo -e "${AMARILLO}▶ $*${NC}"; }
ok()     { echo -e "${VERDE}✔ $*${NC}"; }
error()  { echo -e "${ROJO}✘ $*${NC}" >&2; }

cargar_config() {
  if [[ ! -f "$ENV_FILE" ]]; then
    error "No existe lab.env. Ejecuta primero: ./lab.sh configurar"
    exit 1
  fi
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  local falta=0
  for v in PROJECT_ID ZONE BUCKET_NAME INSTANCE_NAME DISK_NAME; do
    if [[ -z "${!v:-}" ]]; then error "Falta el valor $v en lab.env"; falta=1; fi
  done
  [[ $falta -eq 0 ]] || exit 1
  REGION="${ZONE%-*}"
  export PROJECT_ID ZONE REGION BUCKET_NAME INSTANCE_NAME DISK_NAME
}

requiere_gcloud() {
  if ! command -v gcloud >/dev/null 2>&1; then
    error "gcloud no está instalado. Ejecuta: bash .devcontainer/instalar-gcloud.sh"
    exit 1
  fi
  if [[ -z "$(gcloud auth list --filter=status:ACTIVE --format='value(account)' 2>/dev/null)" ]]; then
    error "No has iniciado sesión. Ejecuta: ./lab.sh login"
    exit 1
  fi
}
