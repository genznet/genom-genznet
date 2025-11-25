#!/bin/bash

# Color Definitions
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
green='\e[32m'
PURPLE='\e[35m'
cyan='\e[36m'
LRED='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
grenbo="\e[92;1m"
blue="\033[0;34m"
Blue="\033[36m"
TEAL='\033[38;5;30m'
# Clear the terminal
clear

# Loading Animation
loading() {
  local pid=$1
  local delay=0.1
  local spin='⣾⣽⣻⡿'  # Gunakan simbol lebih halus
  local color1="\033[1;34m"  # Warna biru muda untuk spinner
  local color2="\033[1;36m"  # Warna biru terang untuk teks
  local color3="\033[1;37m"  # Warna putih untuk teks utama
  local reset="\033[0m"      # Reset warna

  # Menampilkan animasi loading selama proses PID aktif
  while ps -p $pid > /dev/null; do
    local temp=${spin#?}  # Pindahkan karakter pertama ke belakang
    printf "\r ${color2}Please Wait ${color1}[${spin}]${reset}"  # Teks "Please Wait" dengan warna, spinner berubah
    spin=$temp${spin%"$temp"}  # Pindahkan karakter pertama ke belakang untuk spin
    sleep $delay
  done

  # Setelah selesai, tampilkan pesan selesai
  printf "\r ${color2}Please Wait ${color1}[✔]${reset}\n"
}


# System Information
domain=$(cat /etc/xray/domain)
WKT=$(curl -s ipinfo.io/timezone)
IPVPS=$(curl -s ipv4.icanhazip.com)
tram=$(free -m | awk 'NR==2 {print $2}')
swap=$(free -m | awk 'NR==4 {print $2}')
freq=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo)
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo)
knr=$(uname -r)

# Export IP Address
export IP=$(curl -s https://ipinfo.io/ip/)

# Service Status Checks
service_status() {
  systemctl status "$1" | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g'
}

openssh=$(service_status ssh)
ssh_ws=$(systemctl status ws-stunnel.service | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
ss=$(service_status xray)
nginx=$(service_status nginx)
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_status=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
haproxy_service=$(systemctl status client | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
fail2ban_service=$(/etc/init.d/fail2ban status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
cron_service=$(service_status cron)
Iptables=$(service_status netfilter-persistent)
RClocal=$(service_status rc-local)
Autorebot=$(service_status rc-local)
UdpSSH=$(service_status udp-custom)

# Helper function to format status
format_status() {
  if [[ $1 == "running" || $1 == "exited" ]]; then
    echo -e "${YELLOW}⚡${NC} ${GREEN}ONLINE${NC}"
  else
    echo -e "${RED}⛔ OFFLINE${NC}"
  fi
}

# Status Variables
status_openssh=$(format_status "$openssh")
status_ws_epro=$(format_status "$ssh_ws")
status_ss=$(format_status "$ss")
status_nginx=$(format_status "$nginx")
status_ssh=$(format_status "$ssh_service")
status_beruangjatuh=$(format_status "$dropbear_status")
status_haproxy=$(format_status "$haproxy_service")
status_fail2ban=$(format_status "$fail2ban_service")
status_cron=$(format_status "$cron_service")
status_galo=$(format_status "$Iptables")
status_galoo=$(format_status "$RClocal")
status_galooo=$(format_status "$Autorebot")
status_udp=$(format_status "$UdpSSH")

# Display Service Status
clear
echo -e " ${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${BLUE}       🍀 Status of System Services 🍀    ${NC}"
echo -e " ${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e ""
sleep 0.6 & loading $!

# Create a nice box around the service list
services=( 
  "Service Crons              $status_cron" 
  "Service Nginx              $status_nginx" 
  "Service SSH / TUN          $status_ssh" 
  "Service SSH UDP            $status_udp" 
  "Service WS ePRO            $status_ws_epro" 
  "Service Dropbear           $status_beruangjatuh" 
  "Service SlowDns            $status_haproxy" 
  "Service Xray Vmess WS      $status_ss" 
  "Service Xray Vless WS      $status_ss" 
  "Service Xray Trojan WS     $status_ss" 
  "Service Xray Shadowsocks   $status_ss" 
)

# Loop through the services and display each one in a neat box
for service in "${services[@]}"; do
  echo -e "   ❏ ${ORANGE}$service${NC}"
  sleep 0.6 & loading $!
done

    echo -e ""
    echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${PURPLE}      Terimakasih Telah Menggunakan- ${NC}"
    echo -e " ${PURPLE}    Script Credit By HOKAGELEGEND STORE ${NC}"
    echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    echo -e ""
    read -n 1 -s -r -p "      Press any key to back on menu"
    menu
