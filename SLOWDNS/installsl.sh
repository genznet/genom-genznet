#!/bin/bash
# ==========================================
#   SlowDNS (DNSTT) Installer by GENZNET
# ==========================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${GREEN}SLOWDNS BY GENZNET${NC}"
echo -e "${YELLOW}Progress...${NC}"
sleep 2

# ==============================
# 1. CEK DEPENDENCY
# ==============================
echo -e "${BLUE}[*] Cek & install dependency...${NC}"

if ! command -v curl &>/dev/null; then
  apt-get update -y >/dev/null 2>&1
  apt-get install -y curl >/dev/null 2>&1
fi

if ! command -v wget &>/dev/null; then
  apt-get install -y wget >/dev/null 2>&1
fi

if ! command -v jq &>/dev/null; then
  apt-get install -y jq >/dev/null 2>&1
fi

# ==============================
# 2. SETTING DOMAIN & CLOUDFLARE
# ==============================
# Sesuaikan ini dengan domain & akun Cloudflare kamu
DOMAIN="genznet.my.id"                  # ZONE di Cloudflare
CF_ID="agen006.29@gmail.com"       # Email Cloudflare
CF_KEY="6cfefe09bcd3a368e34b5ce8346f90c861c6c"        # Global API Key / API Token

if [ ! -f /etc/xray/domain ]; then
  echo -e "${RED}[!] File /etc/xray/domain tidak ditemukan!${NC}"
  echo -e "${YELLOW}    Pastikan Xray / domain utama sudah di-set dulu.${NC}"
  exit 1
fi

DOMAIN_PATH=$(cat /etc/xray/domain)     # Host utama yang mengarah ke VPS
IP=$(curl -s ipv4.icanhazip.com)

echo -e "${BLUE}[*] Domain utama    : ${NC}${DOMAIN}"
echo -e "${BLUE}[*] Host Xray       : ${NC}${DOMAIN_PATH}"
echo -e "${BLUE}[*] IP VPS          : ${NC}${IP}"

# ==============================
# 3. BUAT NS SUBDOMAIN UNTUK SLOWDNS
# ==============================
ns_domain_cloudflare() {
  echo -e "${BLUE}[*] Mengatur NS subdomain untuk SlowDNS...${NC}"

  # Subdomain acak, contoh: abcd123.dns.genznet.my.id
  SUB=$(tr </dev/urandom -dc a-z0-9 | head -c7)
  NS_DOMAIN="${SUB}.dns.${DOMAIN}"

  echo -e "${BLUE}[*] NS Domain SlowDNS : ${NC}${NS_DOMAIN}"

  # Ambil Zone ID
  ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)

  if [[ -z "$ZONE" || "$ZONE" == "null" ]]; then
    echo -e "${RED}[!] Gagal mengambil Zone ID dari Cloudflare. Cek DOMAIN / CF_ID / CF_KEY.${NC}"
    exit 1
  fi

  # Cek kalau record sudah ada
  RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)

  # Kalau belum ada, buat baru
  if [[ -z "$RECORD" || "$RECORD" == "null" ]]; then
    echo -e "${BLUE}[*] Membuat NS record baru di Cloudflare...${NC}"
    RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
      -H "X-Auth-Email: ${CF_ID}" \
      -H "X-Auth-Key: ${CF_KEY}" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"NS\",\"name\":\"${NS_DOMAIN}\",\"content\":\"${DOMAIN_PATH}\",\"proxied\":false}" \
      | jq -r .result.id)
  else
    echo -e "${YELLOW}[i] NS record sudah ada, akan diupdate...${NC}"
  fi

  # Update record biar pasti sesuai
  curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"NS\",\"name\":\"${NS_DOMAIN}\",\"content\":\"${DOMAIN_PATH}\",\"proxied\":false}" >/dev/null

  echo "${NS_DOMAIN}" > /etc/xray/dns

  echo -e "${GREEN}[OK] NS SlowDNS berhasil di-set: ${NS_DOMAIN}${NC}"
}

# ==============================
# 4. INSTALL DNSTT & GENERATE KEY
# ==============================
setup_dnstt() {
  echo -e "${BLUE}[*] Install DNSTT & generate key...${NC}"

  mkdir -p /etc/slowdns
  cd /etc/slowdns || exit 1

  # Download binary dnstt-server & dnstt-client dari repo kamu
  wget -O dnstt-server "https://raw.githubusercontent.com/genznet/genom-genznet/refs/heads/main/SLOWDNS/dnstt-server" >/dev/null 2>&1
  wget -O dnstt-client "https://raw.githubusercontent.com/genznet/genom-genznet/refs/heads/main/SLOWDNS/dnstt-client" >/dev/null 2>&1

  chmod +x dnstt-server dnstt-client

  # Generate key (server.key & server.pub)
  ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub

  echo -e "${GREEN}[OK] DNSTT terinstall & key sudah dibuat.${NC}"
}

# ==============================
# 5. BUAT SYSTEMD SERVICE
# ==============================
setup_systemd() {
  echo -e "${BLUE}[*] Konfigurasi systemd service untuk SlowDNS...${NC}"

  NS_DOMAIN=$(cat /etc/xray/dns)
  if [[ -z "$NS_DOMAIN" ]]; then
    echo -e "${RED}[!] NS_DOMAIN kosong! Pastikan tahap Cloudflare berhasil.${NC}"
    exit 1
  fi

  # SERVER: dnstt-server di UDP :5300 forward ke 127.0.0.1:443
  cat > /etc/systemd/system/server-sldns.service <<EOF
[Unit]
Description=Server SlowDNS (DNSTT)
Documentation=https://github.com/ycd/dnstt
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dnstt-server -udp :5300 -privkey-file /etc/slowdns/server.key ${NS_DOMAIN} 127.0.0.1:443
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

  # CLIENT: dnstt-client ke VPS_IP:5300 forward ke 127.0.0.1:88
  cat > /etc/systemd/system/client-sldns.service <<EOF
[Unit]
Description=Client SlowDNS (DNSTT)
Documentation=https://github.com/ycd/dnstt
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dnstt-client -udp ${IP}:5300 --pubkey-file /etc/slowdns/server.pub ${NS_DOMAIN} 127.0.0.1:88
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

  echo -e "${GREEN}[OK] Systemd service server-sldns & client-sldns dibuat.${NC}"
}

# ==============================
# 6. ENABLE & START SERVICE
# ==============================
start_services() {
  echo -e "${BLUE}[*] Mengaktifkan service SlowDNS...${NC}"

  systemctl daemon-reload

  systemctl enable server-sldns >/dev/null 2>&1
  systemctl enable client-sldns >/dev/null 2>&1

  systemctl restart server-sldns
  systemctl restart client-sldns

  sleep 1

  srv_status=$(systemctl is-active server-sldns)
  cli_status=$(systemctl is-active client-sldns)

  echo -e "${BLUE}[*] Status server-sldns :${NC} ${srv_status}"
  echo -e "${BLUE}[*] Status client-sldns :${NC} ${cli_status}"

  if [[ "$srv_status" == "active" ]]; then
    echo -e "${GREEN}[OK] Server SlowDNS berjalan.${NC}"
  else
    echo -e "${RED}[!] Server SlowDNS gagal berjalan. Cek: journalctl -u server-sldns -n 30${NC}"
  fi

  if [[ "$cli_status" == "active" ]]; then
    echo -e "${GREEN}[OK] Client SlowDNS berjalan.${NC}"
  else
    echo -e "${YELLOW}[!] Client SlowDNS gagal berjalan (di VPS biasanya tidak wajib).${NC}"
    echo -e "${YELLOW}    Cek log: journalctl -u client-sldns -n 30${NC}"
  fi
}

# ==============================
# EKSEKUSI SEMUA TAHAP
# ==============================
ns_domain_cloudflare
setup_dnstt
setup_systemd
start_services

echo -e ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Instalasi SlowDNS (DNSTT) Selesai!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e " NS DOMAIN : ${YELLOW}$(cat /etc/xray/dns)${NC}"
echo -e " UDP PORT  : ${YELLOW}5300${NC}"
echo -e ""
