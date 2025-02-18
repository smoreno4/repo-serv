#!/bin/bash

# Definir nombre del archivo de salida
REPORT_FILE="informe_red_docker.txt"

# Obtener fecha actual
DATE=$(date)

# Iniciar informe
echo "===== Reporte del Sistema =====" > "$REPORT_FILE"
echo "Fecha: $DATE" >> "$REPORT_FILE"
echo "===============================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Ejecutar los scripts y guardar la salida
bash red.sh >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
bash docker.sh >> "$REPORT_FILE"

# Mostrar mensaje de confirmación
echo "✅ Informe guardado en $REPORT_FILE"
