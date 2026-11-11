#!/usr/bin/env bash
# Inicia sesión en Google Cloud con la cuenta TEMPORAL del laboratorio
# y deja configurados proyecto, región y zona por defecto.
source "$(dirname "$0")/comun.sh"
cargar_config

titulo "Inicio de sesión en Google Cloud"
echo "Usa el 'Username' y 'Password' que aparecen en el panel del laboratorio"
echo "(ábrelo en una ventana de incógnito para no mezclarlo con tu cuenta personal)."
echo

if ! command -v gcloud >/dev/null 2>&1; then
  error "gcloud no está instalado. Ejecuta: bash .devcontainer/instalar-gcloud.sh"; exit 1
fi

paso "gcloud auth login --no-launch-browser"
echo "  1) Abre el enlace que aparece abajo  2) inicia sesión con la cuenta del lab"
echo "  3) acepta los permisos  4) copia el código y pégalo aquí."
gcloud auth login --no-launch-browser --update-adc=false

paso "Configurando proyecto, región y zona"
gcloud config set project "$PROJECT_ID"
gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"

ok "Sesión lista:"
gcloud config list
