#!/bin/bash
REPO="https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/"

wget -q -O /etc/systemd/system/limitvmess.service "${REPO}TOOLS/limitvmess.service" && chmod +x limitvmess.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limitvless.service "${REPO}TOOLS/limitvless.service" && chmod +x limitvless.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limittrojan.service "${REPO}TOOLS/limittrojan.service" && chmod +x limittrojan.service >/dev/null 2>&1
wget -q -O /etc/systemd/system/limitshadowsocks.service "${REPO}TOOLS/limitshadowsocks.service" && chmod +x limitshadowsocks.service >/dev/null 2>&1
wget -q -O /etc/xray/limit.vmess "${REPO}TOOLS/vmess" >/dev/null 2>&1
wget -q -O /etc/xray/limit.vless "${REPO}TOOLS/vless" >/dev/null 2>&1
wget -q -O /etc/xray/limit.trojan "${REPO}TOOLS/trojan" >/dev/null 2>&1
wget -q -O /etc/xray/limit.shadowsocks "${REPO}TOOLS/shadowsocks" >/dev/null 2>&1
chmod +x /etc/xray/limit.vmess
chmod +x /etc/xray/limit.vless
chmod +x /etc/xray/limit.trojan
chmod +x /etc/xray/limit.shadowsocks
systemctl daemon-reload
systemctl enable --now limitvmess
systemctl enable --now limitvless
systemctl enable --now limittrojan
systemctl enable --now limitshadowsocks

cd
wget -q -O /usr/bin/limit-ip "https://github.com/hokagelegend9999/genom/raw/refs/heads/main/TOOLS/limit-ip"
chmod +x /usr/bin/*
cd /usr/bin
sed -i 's/\r//' limit-ip
cd
clear
# // SERVICE LIMIT IP VMESS
cat >/etc/systemd/system/vmip.service << EOF
[Unit]
Description=My
ProjectAfter=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vmip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# // SERVICE LIMIT IP VLESS
cat >/etc/systemd/system/vlip.service << EOF
[Unit]
Description=My
ProjectAfter=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vlip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# // SERVICE LIMIT TROJAN
cat >/etc/systemd/system/trip.service << EOF
[Unit]
Description=My
ProjectAfter=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip trip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl restart vmip
systemctl enable vmip
systemctl restart vlip
systemctl enable vlip
systemctl restart trip
systemctl enable trip

rm -rf /root/fv-tunnel
