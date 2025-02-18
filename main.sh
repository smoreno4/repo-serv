#!/bin/bash

# Definición de colores
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AZUL='\033[0;34m'
RESET='\033[0m'

# Título
echo -e "${AZUL}===== Reporte de Interfaces de Red =====${RESET}"
echo -e "${VERDE}Fecha: $(date)${RESET}"
echo -e "${AZUL}==========================${RESET}\n"

# Filtrar interfaces y mostrar nombre e inet (IP)
ip a | grep -E '^[0-9]+:|inet' | grep -v '127.0.0.1' | while read -r line; do
    # Mostrar nombre de la interfaz
    if echo "$line" | grep -q '^[0-9]'; then
        INTERFACE=$(echo "$line" | awk -F: '{print $2}' | tr -d ' ')
        echo -e "\n${ROJO}${INTERFACE}${RESET}"
    fi
    # Mostrar dirección inet (IP)
    if echo "$line" | grep -q 'inet '; then
        IP=$(echo "$line" | awk '{print $2}' | sed 's/\/.*//')
        echo -e "${VERDE}IP: ${IP}${RESET}"
    fi
done
