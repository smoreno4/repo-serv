#!/bin/bash

# Definir colores ANSI
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}>> Contenedores Docker en ejecución${NC}"
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
echo ""

echo -e "${CYAN}>> Imágenes de Docker${NC}"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
echo ""
