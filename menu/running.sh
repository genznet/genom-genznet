#!/bin/bash

# Color Definitions
RED_BG='\033[41;1;97m' 
GREEN_BG='\033[42;1;97m'
BLUE_BG='\033[44;1;97m'
YELLOW_BG='\033[43;1;97m'
NC='\033[0m'
BOLD='\033[1m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
LIGHT_GREEN='\033[1;32m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
TEAL='\033[38;5;30m'
PURPLE='\033[0;35m'
# Clear the screen
clear

# Function to display a loading bar
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &

    tput civis
    echo -ne "    ${CYAN}Please Wait... ${WHITE}- ${CYAN}["

    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "${GREEN}="
            sleep 0.1s
        done

        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "${CYAN}]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "    ${CYAN}Please Wait... ${WHITE}- ${CYAN}["
    done

    echo -e "${CYAN}]${WHITE} - ⚡ ${LIGHT_GREEN}GOOD${WHITE}"
    tput cnorm
}

# Restart service functions
res1() { systemctl daemon; }
res2() { systemctl restart nginx; }
res3() { systemctl restart xray; }
res4() { systemctl restart rc-local; }
res5() { systemctl restart client; }
res6() { systemctl restart server; }
res7() { systemctl restart ws-dropbear; }
res8() { systemctl restart ws; }
res9() { systemctl restart openvpn; }
res10() { systemctl restart cron; }
res11() { systemctl restart haproxy; }
res12() { systemctl restart netfilter-persistent; }
res13() { systemctl restart squid; }
res14() { systemctl restart udp-custom; }
res15() { systemctl restart ws-stunnel; }
res16() { systemctl restart badvpn1; }
res17() { systemctl restart badvpn2; }
res18() { systemctl restart badvpn3; }
res19() { systemctl restart kyt; }

# Clear the screen again before displaying menu
clear

# Display Menu Header with Border
echo -e " ${MAGENTA}————————————————————————————————————————————————————${NC}"
echo -e "  ${RED_BG}              Restart Service Server              ${NC}"
echo -e " ${MAGENTA}————————————————————————————————————————————————————${NC}"

# Call restart functions with loading bars
echo -e "  ❏ ${ORANGE}service restart x${WHITE}"
fun_bar 'res1'

echo -e "  ❏ ${ORANGE}service restart xx${WHITE}"
fun_bar 'res2'

echo -e "  ❏ ${ORANGE}service restart xxx${WHITE}"
fun_bar 'res3'

echo -e "  ❏ ${ORANGE}service restart xxxx${WHITE}"
fun_bar 'res4'

echo -e "  ❏ ${ORANGE}service restart xxxxx${WHITE}"
fun_bar 'res5'

echo -e "  ❏ ${ORANGE}service restart xxxxxx${WHITE}"
fun_bar 'res6'

echo -e "  ❏ ${ORANGE}service restart xxxxxxx ${WHITE}"
fun_bar 'res7'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxx${WHITE}"
fun_bar 'res8'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxxx${WHITE}"
fun_bar 'res9'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxxxx${WHITE}"
fun_bar 'res10'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxxxxx${WHITE}"
fun_bar 'res11'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxxxxxx${WHITE}"
fun_bar 'res12'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxxxxxxx${WHITE}"
fun_bar 'res13'

echo -e "  ❏ ${ORANGE}service restart xxxxxxxxxxxxxx${WHITE}"
fun_bar 'res14'
fun_bar 'res15'
fun_bar 'res16'
fun_bar 'res17'
fun_bar 'res18'
fun_bar 'res19'

# Final border after all services are processed
    echo " "
    echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${PURPLE}         Terimakasih Telah Menggunakan- ${NC}"
    echo -e " ${PURPLE}      Script Credit By  HOKAGE LEGEND STORE ${NC}"
    echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

# Wait for user input to return to the menu
read -n 1 -s -r -p "     Press any key to go back to the menu"
menu
