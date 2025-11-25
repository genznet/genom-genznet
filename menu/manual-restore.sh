#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BIRU='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
CYAN_BG='\033[46;1;97m'   # Latar belakang cyan cerah dengan teks putih
LIGHT='\033[0;37m'
PINK='\033[0;35m'
ORANGE='\033[38;5;208m'
PINK_BG='\033[45;1;97m'
BIRU_BG='\033[44;1;97m'
RED_BG='\033[41;1;97m'   # Latar belakang pink cerah dengan teks putih
NC='\033[0m'
INDIGO='\033[38;5;54m'
TEAL='\033[38;5;30m'
WHITE='\033[1;37m'

# Fungsi untuk restore data bysftp
clear
cd
unzip backup.zip
sleep 1
cd /root/backup
cp -r passwd /etc/ &> /dev/null
cp -r group /etc/ &> /dev/null
cp -r shadow /etc/ &> /dev/null
cp -r xray /etc/xray/config.json &> /dev/null
cp -r ssh /etc/xray/ssh &> /dev/null
cp -r idchat /usr/bin/idchat &> /dev/null
cp -r token /usr/bin/token &> /dev/null
cp -r id /etc/per/id &> /dev/null
cp -r token2 /etc/per/token &> /dev/null
cp -r loginid /etc/perlogin/id &> /dev/null
cp -r logintoken /etc/perlogin/token &> /dev/null
cp -r public_html /home/vps/ &> /dev/null
cp -r gshadow /etc/ &> /dev/null
cp -r sshx /etc/xray/ &> /dev/null
cp -r vmess /etc/ &> /dev/null
cp -r vless /etc/ &> /dev/null
cp -r trojan /etc/ &> /dev/null
cp -r issue /etc/issue.net &> /dev/null
rm -rf /root/backup
rm -rf /root/backup.zip
clear
# Jalankan proses restore
echo -e "${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN} ❐ Done, restore your Database, By SFTP ❐${NC}"
echo -e "${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
