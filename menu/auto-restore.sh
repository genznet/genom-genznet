#!/bin/bash
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
colornow=$(cat /etc/phreakers/theme/color.conf)
clear
echo ""
echo " This Feature Can Only Be Used According To VPS Data With This Autoscript"
echo " Please Insert VPS Data Backup Link To Restore The Data"
echo ""
read -rp "Link File: " -e url
cd
mkdir -p /root/backup
wget -O backup.zip "$url"
unzip backup.zip  &> /dev/null
rm -f backup.zip
sleep 1
echo Start Restore
cd /root/backup
echo -e "[ ${green}INFO${NC} ] Start Restore . . . "
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
echo ""
echo -e "[ ${green}INFO${NC} ] VPS Data Restore Complete !"
echo ""
echo -e "[ ${green}INFO${NC} ] Restart All Service"
systemctl restart xray
systemctl restart nginx
cd
rm -rf *
sleep 0.5
read -n 1 -s -r -p "Press any key to back on menu"
menu
