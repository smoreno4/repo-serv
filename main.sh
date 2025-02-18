#!/bin/bash

# Definición de colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARILLO='\033[0;33m'
RESET='\033[0m'

# Ruta para guardar el archivo de informe
INFORME="informe_red_docker.txt"

# Asegurarse de que el archivo de informe esté vacío al inicio
> "$INFORME"

# Reporte de Red
echo -e "${AZUL}===== Network Report =====${RESET}" >> "$INFORME"
echo -e "${VERDE}Fecha: $(date)${RESET}" >> "$INFORME"
echo -e "${AZUL}==========================${RESET}\n" >> "$INFORME"
echo -e "${AMARILLO}>> Interfaces de Red Filtradas (eth, docker, br, n4m)${RESET}" >> "$INFORME"
ip a | grep -E 'eth|docker|br|n4m' | grep inet | awk '{print $2}' | sed 's/\/.*//' >> "$INFORME"
echo -e "${AZUL}\n==========================${RESET}" >> "$INFORME"

# Reporte de Docker
echo -e "${AZUL}===== Docker Report =====${RESET}" >> "$INFORME"
echo -e "${VERDE}Fecha: $(date)${RESET}" >> "$INFORME"
echo -e "${AZUL}==========================${RESET}\n" >> "$INFORME"
docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Status}}" >> "$INFORME"

# Confirmación
echo -e "${VERDE}✅ Informe guardado en $INFORME${RESET}"

# Mostrar el contenido del archivo generado
cat "$INFORME"
