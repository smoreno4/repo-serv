#!/bin/bash

# Script para verificar exporters comunes en el servidor local

echo "=== Diagnóstico de exporters comunes en $(hostname) ==="
echo ""

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

# Verificar node_exporter
echo "- node_exporter:"
nr=$(is_running node_exporter)
if [[ $nr -eq 0 ]]; then
  ports=$(find_ports node_exporter)
  echo "  RUNNING - Puertos: ${ports:-no encontrado}"
else
  echo "  NOT RUNNING"
fi
echo ""

# Verificar systemd_exporter
echo "- systemd_exporter:"
sr=$(is_running systemd_exporter)
if [[ $sr -eq 0 ]]; then
  ports=$(find_ports systemd_exporter)
  echo "  RUNNING - Puertos: ${ports:-no encontrado}"
else
  echo "  NOT RUNNING"
fi
echo ""

# Verificar mongodb_exporter
echo "- mongodb_exporter:"
mr=$(is_running mongodb_exporter)
if [[ $mr -eq 0 ]]; then
  ports=$(find_ports mongodb_exporter)
  echo "  RUNNING - Puertos: ${ports:-no encontrado}"
else
  echo "  NOT RUNNING"
fi
echo ""

echo "=== Resumen ==="
echo "node_exporter: $( [[ $nr -eq 0 ]] && echo 'ON' || echo 'OFF' )"
echo "systemd_exporter: $( [[ $sr -eq 0 ]] && echo 'ON' || echo 'OFF' )"
echo "mongodb_exporter: $( [[ $mr -eq 0 ]] && echo 'ON' || echo 'OFF' )"

# Fin del script
