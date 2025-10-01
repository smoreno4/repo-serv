#!/bin/bash

# Obtener hostname completo
HOSTNAME_FULL=$(hostname -f)
echo "========================================="
echo "Reporte de exporters en: $HOSTNAME_FULL"
echo "========================================="
echo ""

declare -A exporters
declare -A exporters_urls

# Exporters y procesos a detectar
exporters=(
  ["node_exporter"]="node_exporter"
  ["systemd_exporter"]="systemd_exporter"
  ["mongodb_exporter"]="mongodb_exporter"
  ["blackbox_exporter"]="blackbox_exporter"
  ["cadvisor"]="cadvisor"
  ["nginx_exporter"]="nginx_exporter"
  ["postgres_exporter"]="postgres_exporter"
)

# URLs oficiales para descarga
exporters_urls=(
  ["node_exporter"]="https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-*-linux-amd64.tar.gz"
  ["systemd_exporter"]="https://github.com/prometheus-community/systemd_exporter/releases/latest/download/systemd_exporter.tar.gz"
  ["mongodb_exporter"]="https://github.com/percona/mongodb_exporter/releases/download/v0.47.1/mongodb_exporter-0.47.1.linux-64-bit.deb"
  ["blackbox_exporter"]="https://github.com/prometheus/blackbox_exporter/releases/latest/download/blackbox_exporter-*-linux-amd64.tar.gz"
  ["cadvisor"]="https://github.com/google/cadvisor/releases/latest/download/cadvisor"
  ["nginx_exporter"]="https://github.com/nginxinc/nginx-prometheus-exporter/releases/latest/download/nginx-prometheus-exporter_linux_amd64"
  ["postgres_exporter"]="https://github.com/prometheus-community/postgres_exporter/releases/latest/download/postgres_exporter-*-linux-amd64.tar.gz"
)

# Función para verificar si un proceso está corriendo
is_running() {
  pgrep -f "$1" > /dev/null 2>&1
  echo $?
}

# Función para encontrar puertos en uso por un proceso
find_ports() {
  local proc_name=$1
  ss -tulnp 2>/dev/null | grep "$proc_name" | awk '{print $5}' | sed -E 's/.*:([0-9]+)/\1/' | sort -u | tr '\n' ', ' | sed 's/, $//'
}

# Diagnóstico y URL
echo "=== Diagnóstico y URLs de exporters en: $HOSTNAME_FULL ==="
echo ""

for exp in "${!exporters[@]}"; do
  echo "- $exp:"
  nr=$(is_running "${exporters[$exp]}")
  if [[ $nr -eq 0 ]]; then
    ports=$(find_ports "${exporters[$exp]}")
    echo "  RUNNING - Puertos: ${ports:-no encontrado}"
  else
    echo "  NOT RUNNING"
  fi
  echo "  URL oficial: ${exporters_urls[$exp]}"
  echo ""
done

# Resumen final con hostname
echo "=== RESUMEN FINAL en: $HOSTNAME_FULL ==="
for exp in "${!exporters[@]}"; do
  nr=$(is_running "${exporters[$exp]}")
  printf "%-17s : %s\n" "$exp" "$( [[ $nr -eq 0 ]] && echo 'ON' || echo 'OFF' )"
done

# Fin

