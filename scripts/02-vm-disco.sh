#!/usr/bin/env bash
# TAREA 2: Crear la VM my-instance y adjuntarle el disco persistente mydisk (200 GB).
source "$(dirname "$0")/comun.sh"
cargar_config
requiere_gcloud

titulo "Tarea 2 · VM + disco persistente"

paso "Verificando que la API de Compute Engine esté habilitada"
gcloud services enable compute.googleapis.com --project="$PROJECT_ID"

# --- 2.1 Máquina virtual -----------------------------------------------------
if gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE" --project="$PROJECT_ID" >/dev/null 2>&1; then
  ok "La VM $INSTANCE_NAME ya existe."
else
  paso "Creando VM $INSTANCE_NAME (e2-medium, Debian, disco de arranque 10 GB estándar, HTTP)"
  gcloud compute instances create "$INSTANCE_NAME" \
    --project="$PROJECT_ID" \
    --zone="$ZONE" \
    --machine-type=e2-medium \
    --image-family=debian-12 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard \
    --tags=http-server
  ok "VM creada."
fi

# --- 2.2 Regla de firewall para HTTP (equivale a marcar "Allow HTTP traffic") --
if gcloud compute firewall-rules describe default-allow-http --project="$PROJECT_ID" >/dev/null 2>&1; then
  ok "La regla de firewall default-allow-http ya existe."
else
  paso "Creando regla de firewall default-allow-http (tcp:80 → etiqueta http-server)"
  gcloud compute firewall-rules create default-allow-http \
    --project="$PROJECT_ID" \
    --network=default \
    --direction=INGRESS \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server
  ok "Regla creada."
fi

# --- 2.3 Disco persistente ---------------------------------------------------
if gcloud compute disks describe "$DISK_NAME" --zone="$ZONE" --project="$PROJECT_ID" >/dev/null 2>&1; then
  ok "El disco $DISK_NAME ya existe."
else
  paso "Creando disco persistente $DISK_NAME de 200 GB en $ZONE"
  gcloud compute disks create "$DISK_NAME" \
    --project="$PROJECT_ID" \
    --zone="$ZONE" \
    --size=200GB
  ok "Disco creado."
fi

# --- 2.4 Adjuntar el disco a la VM -------------------------------------------
if gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE" --project="$PROJECT_ID" \
     --format="value(disks[].source)" | tr ';' '\n' | grep -q "/disks/$DISK_NAME$"; then
  ok "El disco $DISK_NAME ya está adjunto a $INSTANCE_NAME."
else
  paso "Adjuntando $DISK_NAME a $INSTANCE_NAME"
  gcloud compute instances attach-disk "$INSTANCE_NAME" \
    --project="$PROJECT_ID" \
    --zone="$ZONE" \
    --disk="$DISK_NAME"
  ok "Disco adjunto."
fi

gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE" --project="$PROJECT_ID" \
  --format="table(name, machineType.basename(), status, disks[].deviceName.list():label=DISCOS, networkInterfaces[0].accessConfigs[0].natIP:label=IP_EXTERNA)"
