#!/bin/bash

# ==================== CONFIGURATION ====================
USER="$1"
CONFIG_FILE="/etc/xray/config.json"
VMESS_DIR="/etc/vmess"
WWW_DIR="/home/vps/public_html"
CRON_DIR="/etc/cron.d"

# ==================== VALIDATION ====================
# Validasi input user
if [[ -z "$USER" ]]; then
    echo "Error: No username specified"
    echo "Usage: $0 <username>"
    exit 1
fi

# ==================== DATA EXTRACTION ====================
# Cari data user dengan regex yang lebih ketat
USER_DATA=$(grep -E "^#vm ${USER} " "$CONFIG_FILE")
if [[ -z "$USER_DATA" ]]; then
    echo "Error: User $USER not found"
    exit 2
fi

# Ambil expiration date
EXP=$(echo "$USER_DATA" | awk '{print $3}')

# ==================== CONFIGURATION CLEANUP ====================
# Hapus section dari config.json dengan pattern yang lebih akurat
sed -i "/^#vm ${USER} ${EXP}/,/^},{/d" "$CONFIG_FILE"
sed -i "/^#vmg ${USER} ${EXP}/,/^},{/d" "$CONFIG_FILE"

# ==================== FILE CLEANUP ====================
# Hapus file terkait user
rm -f "${WWW_DIR}/vmess-${USER}.txt"
rm -f "${VMESS_DIR}/${USER}IP"
rm -f "${VMESS_DIR}/${USER}login"
rm -f "${CRON_DIR}/trialvmess${USER}"

# ==================== SERVICE RESTART ====================
# Restart service dengan error handling
if ! systemctl restart xray; then
    echo "Error: Failed to restart Xray service"
    exit 3
fi

echo "Success: User $USER has been removed"
exit 0