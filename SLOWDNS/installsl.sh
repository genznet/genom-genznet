#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'

clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'

echo "SLOWDNS BY GENZNET " | lolcat
echo "Progress..." | lolcat
sleep 3 

ns_domain_cloudflare() {
    DOMAIN="genznet.my.id"
    DOMAIN_PATH=$(cat /etc/xray/domain)
    SUB=$(tr </dev/urandom -dc a-z0-9 | head -c7)
    SUB_DOMAIN="${SUB}.${DOMAIN}"
    NS_DOMAIN="${SUB_DOMAIN}.dns.${DOMAIN}"

    CF_ID="agen006.29@gmail.com"      # !!! ganti dengan email Cloudflare kamu
    CF_KEY="6cfefe09bcd3a368e34b5ce8346f90c861c6c"     # !!! ganti dengan API key (jangan share)

    echo "Updating DNS NS for ${NS_DOMAIN}..."

    ZONE=$(
        curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
        -H "Content-Type: application/json" | jq -r .result[0].id
    )

    RECORD=$(
        curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
        -H "Content-Type: application/json" | jq -r .result[0].id
    )

    if [[ "${#RECORD}" -le 10 ]]; then
        RECORD=$(
            curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
            -H "X-Auth-Email: ${CF_ID}" \
            -H "X-Auth-Key: ${CF_KEY}" \
            -H "Content-Type: application/json" \
            --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${DOMAIN_PATH}'","proxied":false}' | jq -r .result.id
        )
    fi

    curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
        -H "Content-Type: application/json" \
        --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${DOMAIN_PATH}'","proxied":false}' >/dev/null

    echo "${NS_DOMAIN}" >/etc/xray/dns
}

setup_dnstt() {
    mkdir -p /etc/slowdns
    cd /etc/slowdns

    wget -O dnstt-server "https://raw.githubusercontent.com/genznet/genom-genznet/refs/heads/main/SLOWDNS/dnstt-server" >/dev/null 2>&1
    wget -O dnstt-client "https://raw.githubusercontent.com/genznet/genom-genznet/refs/heads/main/SLOWDNS/dnstt-client" >/dev/null 2>&1
    chmod +x dnstt-server dnstt-client

    ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub

    wget -O /etc/systemd/system/client.service "https://raw.githubusercontent.com/genznet/genom-genznet/refs/heads/main/SLOWDNS/client" >/dev/null 2>&1
    wget -O /etc/systemd/system/server.service "https://raw.githubusercontent.com/genznet/genom-genznet/refs/heads/main/SLOWDNS/server" >/dev/null 2>&1

    sed -i "s/xxxx/$NS_DOMAIN/g" /etc/systemd/system/client.service 
    sed -i "s/xxxx/$NS_DOMAIN/g" /etc/systemd/system/server.service 
}

ns_domain_cloudflare
setup_dnstt

systemctl daemon-reload
systemctl enable client.service server.service
systemctl restart client.service server.service

rm -f installsl.sh