#!/usr/bin/env bash
# TAREA 1: Crear un bucket de Cloud Storage multirregional en US.
source "$(dirname "$0")/comun.sh"
cargar_config
requiere_gcloud

titulo "Tarea 1 · Bucket de Cloud Storage"

if gcloud storage buckets describe "gs://$BUCKET_NAME" --project="$PROJECT_ID" >/dev/null 2>&1; then
  ok "El bucket gs://$BUCKET_NAME ya existe (no se vuelve a crear)."
else
  paso "Creando gs://$BUCKET_NAME en la multirregión US"
  gcloud storage buckets create "gs://$BUCKET_NAME" \
    --project="$PROJECT_ID" \
    --location=US \
    --default-storage-class=STANDARD
  ok "Bucket creado."
fi

gcloud storage buckets describe "gs://$BUCKET_NAME" \
  --format="table(name, location, location_type, default_storage_class)"
