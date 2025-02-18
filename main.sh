#!/bin/bash

# Definir colores ANSI
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # Sin color

# Nombre del archivo de salida con marca de tiempo
REPORT_FILE="network_report_$(date +'%Y%m%d_%H%M%S').txt"

# Encabezado del informe
echo -e "${RED}===== Network Report =====${NC}" > "$REPORT_FILE"
echo -e "${GREEN}Fecha: $(date)${NC}" >> "$REPORT_FILE"
echo -e "${RED}==========================${NC}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Obtener información de las interfaces de red filtradas
echo -e "${CYAN}>> Interfaces de Red Filtradas (eth, docker, br, n4m)${NC}" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Extraer solo interfaces que contienen eth, docker, br o n4m y sus IPs
ip a | awk '
    /: eth|: docker|: br|: n4m/ {iface=$2; gsub(":", "", iface)}
    /inet / {print iface, $2}
' >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"

# Mostrar mensaje con la ubicación del informe
echo -e "${BLUE}Informe generado: $REPORT_FILE${NC}"
