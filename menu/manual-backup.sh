#!/bin/bash
clear

date=$(date +"%Y-%m-%d")
vps_ip=$(curl -s ifconfig.me) # Mendapatkan IP VPS
domain=$(cat /etc/xray/domain 2>/dev/null || echo "Tidak ditemukan") # Mendapatkan domain, jika ada

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


# Fungsi untuk backup data manual
clear
source /etc/hokage/token.json
if [ -f "/etc/hokage/token.json" ]; then
rm -rf /root/backup
mkdir /root/backup
cp -r /etc/passwd /root/backup/ &> /dev/null
cp -r /etc/group /root/backup/ &> /dev/null
cp -r /etc/shadow /root/backup/ &> /dev/null
cp -r /etc/gshadow /root/backup/ &> /dev/null
cp -r /usr/bin/idchat /root/backup/ &> /dev/null
cp -r /usr/bin/token /root/backup/ &> /dev/null
cp -r /etc/per/id /root/backup/ &> /dev/null
cp -r /etc/per/token /root/backup/token2 &> /dev/null
cp -r /etc/perlogin/id /root/backup/loginid &> /dev/null
cp -r /etc/perlogin/token /root/backup/logintoken &> /dev/null
cp -r /etc/xray/config.json /root/backup/xray &> /dev/null
cp -r /etc/xray/ssh /root/backup/ssh &> /dev/null
cp -r /home/vps/public_html /root/backup/public_html &> /dev/null
cp -r /etc/xray/sshx /root/backup/sshx &> /dev/null
cp -r /etc/vmess /root/backup/vmess &> /dev/null
cp -r /etc/vless /root/backup/vless &> /dev/null
cp -r /etc/trojan /root/backup/trojan &> /dev/null
cp -r /etc/issue.net /root/backup/issue &> /dev/null
cd /root
zip -r backup.zip backup > /dev/null 2>&1
curl -F chat_id="${ID}" \
     -F document=@"/root/backup.zip" -F caption="
=================================
『 Successfully backup your Database 』
=================================
◈ IP VPS  : ${vps_ip}
◈ DOMAIN  : ${domain}
◈ Tanggal : ${date}
◈ Version   : v.3.0 Original 
◈ Built By  : @HookageLegend 
================================= 
➣ How To Restore ?
➣ Use SFTP
➣ Go to /root
➣ Replace file backup.zip
================================= 
🍀 Gunakakan SFTP Remote 🍀 
================================= 
" https://api.telegram.org/bot${TOKEN}/sendDocument &> /dev/null

cd /root
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${PINK}      ❐ MENU MANUAL BACKUP ❐ ${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${ORANGE}  🍀 POWERED BY @HookageLegend 🍀  ${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" 
echo -e " ${GREEN}      ❐ Successfully Backup ❐${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${GREEN} File backup terkirim ke Telegram BOT.${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${PURPLE}   Terimakasih Telah Menggunakan-${NC}"
echo -e " ${PURPLE}  Script Credit By  HOKAGE LEGEND STORE${NC}"
echo -e " ${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
exit 0
fi
echo -e "${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}     ❐ BOT TOKEN TIDAK TERSEDIA ❐${NC}"
echo -e "${TEAL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
sleep 1
clear
mkdir -p /etc/hokage/
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}       ❐ MENU MANUAL BACKUP ❐ ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "$(echo -e "${ORANGE}➽ Masukkan API Key bot Telegram Kamu: ${NC}")" token
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
sleep 0.2
    read -p "$(echo -e "${PINK}➽ Masukkan Chat ID Telegram Kamu: ${NC}")" id
sleep 1
echo "
TOKEN="${token}"
ID="${id}"
" >/etc/hokage/token.json

# Fungsi untuk mengaktifkan crontab
enable_crontab() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e ""
    clear
    read -p "$(echo -e " ❖${YELLOW} Aktifkan crontab setiap 24 Jam ? (y/N): ${NC}")" enable_crontab
    if [[ "$enable_crontab" =~ ^[Yy]$ ]]; then
        (crontab -l 2>/dev/null; echo "0 */23 * * * /usr/bin/hokage-manual-backup") | crontab -
        echo -e " ❖${GREEN} Crontab telah diaktifkan.${NC}"
    else
        echo -e "${YELLOW}❖ Crontab tidak diaktifkan.${NC}"
        echo -e ""
    fi
}

# Jalankan fungsi enable_crontab
enable_crontab
