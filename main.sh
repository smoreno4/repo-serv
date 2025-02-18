#!/bin/bash

# Nombre del archivo de salida con marca de tiempo
REPORT_FILE="network_report_$(date +'%Y%m%d_%H%M%S').txt"

# Encabezado del informe
echo "===== Network Report =====" > "$REPORT_FILE"
echo "Fecha: $(date)" >> "$REPORT_FILE"
echo "==========================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Obtener información de las interfaces de red
echo ">> Interfaces de Red (ip a)" >> "$REPORT_FILE"
ip a >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Mostrar mensaje con la ubicación del informe
echo "Informe generado: $REPORT_FILE"
