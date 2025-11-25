#!/bin/bash

# Direktori file kuota SSH
KUOTA_DIR="/etc/kuota-ssh"

# Memastikan direktori ada
if [ ! -d "$KUOTA_DIR" ]; then
    exit 0
fi

# Loop melalui setiap file pengguna di direktori kuota
for userfile in "$KUOTA_DIR"/*; do
    if [ -f "$userfile" ]; then
        USERNAME=$(basename "$userfile")
        UID=$(id -u "$USERNAME" 2>/dev/null)

        # Lanjutkan hanya jika pengguna ada di sistem
        if [ -n "$UID" ]; then
            # Dapatkan total byte dari iptables (INPUT + OUTPUT)
            BYTES_IN=$(iptables -L INPUT -v -n -x | grep "owner $UID" | awk '{print $2}')
            BYTES_OUT=$(iptables -L OUTPUT -v -n -x | grep "owner $UID" | awk '{print $2}')

            # Jika data kosong (belum ada traffic), set ke 0
            : ${BYTES_IN:=0}
            : ${BYTES_OUT:=0}

            # Jumlahkan total pemakaian
            TOTAL_BYTES=$((BYTES_IN + BYTES_OUT))

            # Update nilai USAGE_BYTES di file kuota menggunakan sed
            sed -i "s/^USAGE_BYTES=.*/USAGE_BYTES=\"${TOTAL_BYTES}\"/" "$userfile"
        fi
    fi
done
