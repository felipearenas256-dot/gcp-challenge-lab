#!/usr/bin/env bash
# Borra los recursos creados (solo si practicas en un proyecto propio;
# en Google Skills NO hace falta: el proyecto temporal se elimina solo al terminar).
source "$(dirname "$0")/comun.sh"
cargar_config
requiere_gcloud
set +e

titulo "Limpieza de recursos"
read -r -p "Esto ELIMINA $INSTANCE_NAME, $DISK_NAME y gs://$BUCKET_NAME. ¿Continuar? (escribe si): " R
[[ "$R" == "si" ]] || { echo "Cancelado."; exit 0; }

gcloud compute instances delete "$INSTANCE_NAME" --zone="$ZONE" --project="$PROJECT_ID" --quiet
gcloud compute disks delete "$DISK_NAME" --zone="$ZONE" --project="$PROJECT_ID" --quiet
gcloud storage rm --recursive "gs://$BUCKET_NAME"
ok "Recursos eliminados."
