#!/usr/bin/env bash
# Revisa las 3 tareas igual que lo haría "Check my progress".
source "$(dirname "$0")/comun.sh"
cargar_config
requiere_gcloud
set +e

titulo "Verificación del Challenge Lab"
APROBADAS=0

# Tarea 1
LOC=$(gcloud storage buckets describe "gs://$BUCKET_NAME" --project="$PROJECT_ID" --format="value(location)" 2>/dev/null)
if [[ "$LOC" == "US" ]]; then ok "Tarea 1: bucket gs://$BUCKET_NAME en multirregión US"; ((APROBADAS++))
else error "Tarea 1: bucket gs://$BUCKET_NAME no existe o no está en US (ubicación: ${LOC:-ninguna})"; fi

# Tarea 2
DATOS=$(gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE" --project="$PROJECT_ID" \
         --format="value(machineType.basename(), disks[].source)" 2>/dev/null)
if [[ -n "$DATOS" ]] && grep -q "e2-medium" <<<"$DATOS" && grep -q "/disks/$DISK_NAME" <<<"$DATOS"; then
  ok "Tarea 2: VM $INSTANCE_NAME (e2-medium) con el disco $DISK_NAME adjunto"; ((APROBADAS++))
else error "Tarea 2: falta la VM, el tipo e2-medium o el disco adjunto"; fi

# Tarea 3
IP=$(gcloud compute instances describe "$INSTANCE_NAME" --zone="$ZONE" --project="$PROJECT_ID" \
      --format="value(networkInterfaces[0].accessConfigs[0].natIP)" 2>/dev/null)
if [[ -n "$IP" ]] && curl -s --max-time 5 "http://$IP" | grep -qi "welcome to nginx"; then
  ok "Tarea 3: NGINX responde en http://$IP"; ((APROBADAS++))
else error "Tarea 3: NGINX no responde en http://${IP:-?}"; fi

echo
echo -e "${AZUL}Resultado: $APROBADAS / 3 tareas completas${NC}"
[[ $APROBADAS -eq 3 ]] && echo "Ahora pulsa 'Check my progress' en cada tarea del laboratorio."
