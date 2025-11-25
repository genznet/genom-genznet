#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/phreakers/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
COLOR1="$(cat /etc/phreakers/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/phreakers/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
###########- END COLOR CODE -##########
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}                 ${WH}⇱ UPDATE ⇲                    ${NC} $COLOR1 $NC"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}⇱ SCRIPT TERBARU ⇲                ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"


#hapus menu
rm -rf m-tcp
rm -rf m-theme
rm -rf m-trojan
rm -rf m-update
rm -rf m-vless
rm -rf m-vmess
rm -rf menu
rm -rf auto-backup
rm -rf auto-restore
rm -rf manual-backup
rm -rf manual-restore
rm -rf menu-backup
rm -rf running
rm -rf sshws
rm -rf system
rm -rf tendang
rm -rf trial
rm -rf trialssh
rm -rf trialtrojan
rm -rf trialvless
rm -rf trialvmess
rm -rf update

rm -rf cleaner
rm -rf m-allxray
rm -rf xraylimit
rm -rf xp
rm -rf autocpu
rm -rf bantwidth
rm -rf bbr
rm -rf ins-xray
rm -rf lolcat
rm -rf set-br
rm -rf slowdns
rm -rf ssh-vpn
rm -rf strt
rm -rf udp-custom
rm -rf vpn
rm -rf limit
rm -rf quota
rm -rf trojan
rm -rf vless
rm -rf vmess
rm -rf insshws
rm -rf online
rm -rf ceklimit
rm -rf online-xray
rm -rf atur-backup
rm -rf backup
rm -rf restore
rm -rf admin
rm -rf online-vmess
rm -rf online-vless
rm -rf online-troja
rm -rf online-sshws
rm -rf update-usage
rm -rf update-ssh-usage

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
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

wow() {

wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/menu.sh" && chmod +x /usr/bin/menu
wget -q -O /usr/bin/update "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/update.sh" && chmod +x /usr/bin/update
wget -q -O /usr/bin/m-tcp "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/m-tcp.sh" && chmod +x /usr/bin/m-tcp

wget -q -O /usr/bin/m-theme "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/m-theme.sh" && chmod +x /usr/bin/m-theme
wget -q -O /usr/bin/m-vmess "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/m-vmess.sh" && chmod +x /usr/bin/m-vmess
wget -q -O /usr/bin/m-vless "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/m-vless.sh" && chmod +x /usr/bin/m-vless
wget -q -O /usr/bin/m-trojan "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/m-trojan.sh" && chmod +x /usr/bin/m-trojan

wget -q -O /usr/bin/system "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/system.sh" && chmod +x /usr/bin/system
wget -q -O /usr/bin/sshws "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/sshws.sh" && chmod +x /usr/bin/sshws
wget -q -O /usr/bin/running "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/running.sh" && chmod +x /usr/bin/running
wget -q -O /usr/bin/cekservice "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/cekservice.sh" && chmod +x /usr/bin/cekservice
wget -q -O /usr/bin/m-update "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/m-update.sh" && chmod +x /usr/bin/m-update
wget -q -O /usr/bin/tendang "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/tendang.sh" && chmod +x /usr/bin/tendang
wget -q -O /usr/bin/check-port "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/check-port.sh" && chmod +x /usr/bin/check-port

wget -q -O /usr/bin/menu-backup "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/menu-backup" && chmod +x /usr/bin/menu-backup
wget -q -O /usr/bin/auto-backup "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/auto-backup.sh" && chmod +x /usr/bin/auto-backup
wget -q -O /usr/bin/auto-restore "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/auto-restore.sh" && chmod +x /usr/bin/auto-restore
wget -q -O /usr/bin/manual-backup "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/manual-backup.sh" && chmod +x /usr/bin/manual-backup
wget -q -O /usr/bin/manual-restore "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/manual-restore.sh" && chmod +x /usr/bin/manual-restore

wget -q -O /usr/bin/xraylimit "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/xraylimit.sh" && chmod +x /usr/bin/xraylimit
wget -q -O /usr/bin/trialvmess "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/trialvmess.sh" && chmod +x /usr/bin/trialvmess
wget -q -O /usr/bin/trialvless "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/trialvless.sh" && chmod +x /usr/bin/trialvless
wget -q -O /usr/bin/trialtrojan "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/trialtrojan.sh" && chmod +x /usr/bin/trialtrojan
wget -q -O /usr/bin/trialssh "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/trialssh.sh" && chmod +x /usr/bin/trialssh
wget -q -O /usr/bin/trial "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/trial.sh" && chmod +x /usr/bin/trial
wget -q -O /usr/bin/trojan-online "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/trojan-online" && chmod +x /usr/bin/trojan-online
wget -q -O /usr/bin/ceklimit "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/ceklimit" && chmod +x /usr/bin/ceklimit
wget -q -O /usr/bin/online "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/online" && chmod +x /usr/bin/online
wget -q -O /usr/bin/atur-backup "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/atur-backup" && chmod +x /usr/bin/atur-backup
wget -q -O /usr/bin/online-xray "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/online-xray" && chmod +x /usr/bin/online-xray
wget -q -O /usr/bin/backup "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/backup" && chmod +x /usr/bin/backup
wget -q -O /usr/bin/restore "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/restore" && chmod +x /usr/bin/restore
wget -q -O /usr/bin/admin "https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/menu/admin" && chmod +x /usr/bin/admin
wget -q -O /usr/bin/online-vmess "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/online-vmess" && chmod +x /usr/bin/online-vmess
wget -q -O /usr/bin/online-vless "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/online-vless" && chmod +x /usr/bin/online-vless
wget -q -O /usr/bin/online-trojan "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/online-trojan" && chmod +x /usr/bin/online-trojan
wget -q -O /usr/bin/online-sshws "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/online-sshws" && chmod +x /usr/bin/online-sshws
wget -q -O /usr/bin/update-usage "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/update-usage" && chmod +x /usr/bin/update-usage
wget -q -O /usr/bin/update-ssh-usage "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/menu/update-ssh-usage.sh" && chmod +x /usr/bin/update-ssh-usage


chmod +x m-tcp
chmod +x m-theme
chmod +x m-trojan
chmod +x m-update
chmod +x m-vless
chmod +x m-vmess
chmod +x menu
chmod +x auto-backup
chmod +x auto-restore
chmod +x manual-backup
chmod +x manual-restore
chmod +x menu-backup
chmod +x running
chmod +x sshws
chmod +x system
chmod +x tendang
chmod +x trial
chmod +x trialssh
chmod +x trialtrojan
chmod +x trialvless
chmod +x trialvmess
chmod +x update

chmod +x cleaner
chmod +x m-allxray
chmod +x xraylimit
chmod +x xp
chmod +x autocpu
chmod +x bantwidth
chmod +x bbr
chmod +x ins-xray
chmod +x lolcat
chmod +x set-br
chmod +x slowdns
chmod +x ssh-vpn
chmod +x strt
chmod +x udp-custom
chmod +x vpn
chmod +x limit
chmod +x quota
chmod +x trojan
chmod +x vless
chmod +x vmess
chmod +x insshws
chmod +x trojan-online
chmod +x ceklimit
chmod +x online
chmod +x online-xray
chmod +x online-trojan
chmod +x backup
chmod +x restore
chmod +x admin
chmod +x online-vmess
chmod +x online-vless
chmod +x online-trojan
chmod +x online-sshws
chmod +x update-usage
chmod +x update-ssh-usage
clear

}
echo -e ""
echo -e " ═════════════════════════════════════════════════"
echo -e "\033[1;91m   Please Wait, Update Script...\033[1;37m"
fun_bar 'wow'
echo -e ""

cd
menu
