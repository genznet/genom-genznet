#!/bin/bash

# ==================== CONFIGURATION ====================
THEME_DIR="/etc/phreakers/theme"
COLOR_CONF="${THEME_DIR}/color.conf"
AUTHOR_FILE="/etc/profil"

# ==================== COLOR FUNCTIONS ====================
load_colors() {
    colornow=$(cat "$COLOR_CONF" 2>/dev/null)
    NC="\e[0m"
    COLOR1=$(grep -w "TEXT" "${THEME_DIR}/${colornow}" | cut -d: -f2 | sed 's/ //g')
    COLBG1=$(grep -w "BG" "${THEME_DIR}/${colornow}" | cut -d: -f2 | sed 's/ //g')
    WH='\033[1;37m'
}

# ==================== DISPLAY FUNCTIONS ====================
show_header() {
    echo -e " ${COLOR1}╔════════════════════════════════════════════════════╗${NC}"
    echo -e " ${COLOR1}║${COLBG1}                ${WH}• THEMES PANEL MENU •               ${NC}${COLOR1}║"
    echo -e " ${COLOR1}╚════════════════════════════════════════════════════╝${NC}"
}

show_options() {
    echo -e " ${COLOR1}╔════════════════════════════════════════════════════╗${NC}"
    echo -e " ${COLOR1}║ ${WH}[01]${NC} ${COLOR1}• ${WH}COLOR RED           ${WH}[04]${NC} ${COLOR1}• ${WH}COLOR GREEN      ${COLOR1}║${NC}"
    echo -e " ${COLOR1}║ ${WH}[02]${NC} ${COLOR1}• ${WH}COLOR YELLOW        ${WH}[05]${NC} ${COLOR1}• ${WH}COLOR BLUE       ${COLOR1}║${NC}"
    echo -e " ${COLOR1}║ ${WH}[03]${NC} ${COLOR1}• ${WH}COLOR MAGENTA       ${WH}[06]${NC} ${COLOR1}• ${WH}COLOR CYAN       ${COLOR1}║${NC}"
    echo -e " ${COLOR1}╚════════════════════════════════════════════════════╝${NC}"
}

show_footer() {
    local author=$(cat "$AUTHOR_FILE" 2>/dev/null || echo "Unknown")
    echo -e " ${COLOR1}╔══════════════════════ ${WH}CREDIT BY${NC} ${COLOR1}═══════════════════╗${NC}"
    echo -e " ${COLOR1}║             ${WH}• HOAGE LEGEND STORE •                ${COLOR1}║${NC}"
    echo -e " ${COLOR1}╚════════════════════════════════════════════════════╝${NC}"
}

# ==================== THEME FUNCTIONS ====================
clear
change_theme() {
    local color=$1
    echo "${color}" > "${COLOR_CONF}"
    echo -e ""
    echo -e "  ${COLOR1}════════════════════════════════════════════════════${NC}"
    echo -e "          ${WH}SUCCESS: ${COLOR1}Theme changed to ${WH}${color}${NC}"
}

# ==================== MAIN PROGRAM ====================
load_colors
clear

show_header
show_options
show_footer


echo -ne "\n ${WH}Select menu ${COLOR1}: ${WH}"
read -r colormenu

case $colormenu in
    01|1) change_theme "red" ;;
    02|2) change_theme "yellow" ;;
    03|3) change_theme "magenta" ;;
    04|4) change_theme "green" ;;
    05|5) change_theme "blue" ;;
    06|6) change_theme "cyan" ;;
    00|0) clear; menu ;;
    *) clear; m-theme ;;
esac

echo -e "\n${NC}"
read -n 1 -s -r -p "          Press any key to return to menu"
clear
menu
