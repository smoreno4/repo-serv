#!/bin/bash

# Ruta para guardar el archivo de informe
INFORME="informe_red_docker.txt"

# Asegurarse de que el archivo de informe esté vacío al inicio
> "$INFORME"

# Reporte de Red
echo "===== Network Report =====" >> "$INFORME"
echo "Fecha: $(date)" >> "$INFORME"
echo "==========================\n" >> "$INFORME"
echo ">> Interfaces de Red Filtradas (eth, docker, br, n4m)" >> "$INFORME"
ip a | grep -E 'eth|docker|br|n4m' | grep inet | awk '{print $2}' | sed 's/\/.*//' >> "$INFORME"

# Separador entre los informes
echo "\n\n==========================\n" >> "$INFORME"

# Reporte de Docker
echo "===== Docker Report =====" >> "$INFORME"
echo "Fecha: $(date)" >> "$INFORME"
echo "==========================\n" >> "$INFORME"
docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Status}}" >> "$INFORME"

# Confirmación
echo "✅ Informe guardado en $INFORME"
