#!/bin/bash

# Definir los nombres de los archivos de los scripts
RED_SCRIPT="red.sh"
DOCKER_SCRIPT="docker.sh"
REPORT_FILE="informe_red_docker.txt"

# Definir la URL del repositorio para los scripts
REPO_URL="https://raw.githubusercontent.com/smoreno4/repo-serv/main/"

# Verificar si los scripts están presentes, si no, descargarlos
if [ ! -f "$RED_SCRIPT" ]; then
    echo "🔽 Descargando $RED_SCRIPT..."
    curl -sL -o "$RED_SCRIPT" "${REPO_URL}${RED_SCRIPT}"
fi

if [ ! -f "$DOCKER_SCRIPT" ]; then
    echo "🔽 Descargando $DOCKER_SCRIPT..."
    curl -sL -o "$DOCKER_SCRIPT" "${REPO_URL}${DOCKER_SCRIPT}"
fi

# Hacer los scripts ejecutables
chmod +x "$RED_SCRIPT" "$DOCKER_SCRIPT"

# Obtener fecha actual
DATE=$(date)

# Iniciar informe
echo "===== Reporte del Sistema =====" > "$REPORT_FILE"
echo "Fecha: $DATE" >> "$REPORT_FILE"
echo "===============================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Ejecutar los scripts y guardar la salida
bash "$RED_SCRIPT" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
bash "$DOCKER_SCRIPT" >> "$REPORT_FILE"

# Mostrar mensaje de confirmación
echo "✅ Informe guardado en $REPORT_FILE"
