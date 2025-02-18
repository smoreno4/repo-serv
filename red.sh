#!/bin/bash

# Definir colores ANSI
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}>> Interfaces de Red Filtradas (eth, docker, br, n4m)${NC}"
echo ""

ip a | awk '
    /: eth|: docker|: br|: n4m/ {iface=$2; gsub(":", "", iface)}
    /inet / && $2 !~ /^127\.0\.0\.1/ {print iface "\n" $2 "\n"}
'
