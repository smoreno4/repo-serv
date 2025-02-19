#!/bin/bash

echo "Ejecutando comandos y mostrando resultados al final..."

# Definir comandos en un array
comandos=(
    "ip addr show | grep -E 'lo|eth|docker|br|veth|n4m' | awk '/inet/ {print \$2, \$NF}'"
    "cat ~/.ssh/authorized_keys"
    "systemctl list-units --type=service --state=running"
)

# Archivo temporal para almacenar la salida
output_file=$(mktemp)

# Ejecutar cada comando y guardar el resultado
for cmd in "${comandos[@]}"; do
    echo "➜ Ejecutando: $cmd" >> "$output_file"
    eval "$cmd" >> "$output_file" 2>&1
    echo -e "\n-------------------------\n" >> "$output_file"
done

# Mostrar el resultado completo al final
cat "$output_file"

# Eliminar archivo temporal
rm -f "$output_file"
