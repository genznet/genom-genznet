#!/bin/bash
# Proxy For Edukasi & Imclass



wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/WEBSOCKET/ws-dropbear
chmod +x /usr/local/bin/ws-dropbear

# Installing Service
cat > /etc/systemd/system/ws-nontls.service << END
[Unit]
Description=Python Proxy Mod By SFUSION
Documentation=https://t.me/abecasdee
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-dropbear
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

sudo systemctl status dropbear.service
sudo systemctl restart dropbear.service
sudo systemctl enable dropbear.service
sudo systemctl restart ws-nontls.service

wget -O /usr/local/bin/ws-ovpn https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/WEBSOCKET/ws-ovpn.py
chmod +x /usr/local/bin/ws-ovpn

# Installing Service
cat > /etc/systemd/system/ws-ovpn.service << END
[Unit]
Description=Python Proxy Mod By HOKAGE LEGEND
Documentation=https://t.me/hokagelegend1
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-ovpn 2086
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws-ovpn
systemctl restart ws-ovpn

wget -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/hokagelegend9999/genom/refs/heads/main/WEBSOCKET/ws-stunnel
chmod +x /usr/local/bin/ws-stunnel

# Installing Service
cat > /etc/systemd/system/ws-stunnel.service << END
[Unit]
Description=Python Proxy Mod By HOKAGE LEGEND
Documentation=https://t.me/hokagelegend1
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O /usr/local/bin/ws-stunnel
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service
sudo systemctl daemon-reload
sudo systemctl restart ws-stunnel.service
