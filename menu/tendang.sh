#!/bin/bash
set -euo pipefail

# ==================== CONFIGURATION ====================
CONFIG_DIR="/etc/xray"
LOG_DIR="/var/log"
SSHX_DIR="${CONFIG_DIR}/sshx"
DOMAIN_FILE="${CONFIG_DIR}/domain"
USER_FILE="/etc/user.txt"
TMP_DIR="/tmp"
LOCK_DIR="/etc/xray/sshx/listlock"
TELEGRAM_API="https://api.telegram.org/bot$(cat /etc/perlogin/token)/sendMessage"
CHAT_ID=$(cat /etc/perlogin/id)
MAX_RETRY=3

# ==================== INITIALIZATION ====================
init_vars() {
    colornow=$(cat /etc/phreakers/theme/color.conf)
    NC="\e[0m"
    RED="\033[0;31m"
    COLOR1=$(grep -w "TEXT" "/etc/phreakers/theme/$colornow" | cut -d: -f2 | sed 's/ //g')
    COLBG1=$(grep -w "BG" "/etc/phreakers/theme/$colornow" | cut -d: -f2 | sed 's/ //g')
    WH='\033[1;37m'
    
    DOMAIN=$(<"$DOMAIN_FILE")
    ISP=$(<"${CONFIG_DIR}/isp")
    CITY=$(<"${CONFIG_DIR}/city")
    DATE=$(date +'%Y-%m-%d')
    TIME=$(date +'%H:%M:%S')
}

# ==================== LOG PROCESSING ====================
detect_os() {
    [[ -e "${LOG_DIR}/auth.log" ]] && { OS=1; LOG_FILE="${LOG_DIR}/auth.log"; return; }
    [[ -e "${LOG_DIR}/secure" ]] && { OS=2; LOG_FILE="${LOG_DIR}/secure"; return; }
    echo "Error: No valid log file found" >&2
    exit 1
}

process_logs() {
    local service=$1
    local pattern=$2
    local user_field=$3
    
    grep -i "$pattern" "$LOG_FILE" > "${TMP_DIR}/log-${service}.txt"
    
    while read -r line; do
        pid=$(echo "$line" | grep -oP '(?<=\[)\d+(?=\])')
        user=$(echo "$line" | awk -v field="$user_field" '{print $field}' | sed "s/'//g")
        ip=$(echo "$line" | awk '{print $(NF-2)}')
        
        [[ -n "$user" ]] && process_user "$user" "$ip" "$pid"
    done < "${TMP_DIR}/log-${service}.txt"
}

# ==================== USER PROCESSING ====================
process_user() {
    local user=$1
    local ip=$2
    local pid=$3
    
    if [[ " ${users[@]} " =~ " $user " ]]; then
        index=$(get_user_index "$user")
        login_count[$index]=$((login_count[index] + 1))
        pids[$index]="${pids[$index]} $pid"
        echo "$user $TIME : $ip" >> "${TMP_DIR}/ssh"
    fi
}

get_user_index() {
    for i in "${!users[@]}"; do
        [[ "${users[$i]}" == "$1" ]] && echo $i && return
    done
    echo -1
}

# ==================== NOTIFICATION HANDLER ====================
send_telegram() {
    local message=$1
    for ((i=0; i<MAX_RETRY; i++)); do
        response=$(curl -s --max-time 10 -d "chat_id=${CHAT_ID}&text=${message}&parse_mode=html&disable_web_page_preview=1" "$TELEGRAM_API")
        [[ "$response" == *"\"ok\":true"* ]] && break
        sleep 1
    done
}

generate_message() {
    local username=$1
    local count=$2
    local log_entries=$3
    
    cat <<EOF
<code>◇━━━━━━━━━━━━━━◇</code>
<b>⚠️ SSH MULTI LOGIN ALERT ⚠️</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN:</b> ${DOMAIN}
<b>ISP:</b> ${ISP} (${CITY})
<b>DATE:</b> ${DATE}
<b>USER:</b> ${username}
<b>LOGIN ATTEMPTS:</b> ${count}
<code>◇━━━━━━━━━━━━━━◇</code>
<b>LOGIN ACTIVITY:</b>
${log_entries}
<code>◇━━━━━━━━━━━━━━◇</code>
EOF
}

# ==================== MAIN LOGIC ====================
main() {
    init_vars
    detect_os
    trap 'rm -rf "${TMP_DIR}"/log-* "${TMP_DIR}"/ssh' EXIT
    
    mapfile -t users < <(grep "/home/" /etc/passwd | cut -d: -f1 | tr -d "'")
    declare -a login_count=() pids=()
    
    # Initialize arrays
    for _ in "${users[@]}"; do
        login_count+=(0)
        pids+=("")
    done

    # Process services
    process_logs "dropbear" "Password auth succeeded" 10
    process_logs "sshd" "Accepted password for" 9
    
    # Check limits
    for i in "${!users[@]}"; do
        user_limit=$(<"${SSHX_DIR}/${users[$i]}IP")
        [[ ${login_count[$i]} -le $user_limit ]] && continue
        
        handle_violation "${users[$i]}" "${login_count[$i]}"
    done
    
    restart_services
}

handle_violation() {
    local user=$1
    local count=$2
    local log_entries=$(grep -w "$user" "${TMP_DIR}/ssh" | cut -d' ' -f2- | nl -s '. ')
    local threshold=$(<"${SSHX_DIR}/notif" || echo 3)
    
    # Send notification
    message=$(generate_message "$user" "$count" "$log_entries")
    send_telegram "$message"
    
    # Lock user if threshold exceeded
    if (( count >= threshold )); then
        lock_user "$user"
        echo "### $user $(get_exp_date "$user") $(get_user_pass "$user")" >> "$LOCK_DIR"
    fi
}

lock_user() {
    passwd -l "$1" >/dev/null 2>&1
    rm -rf "${SSHX_DIR}/${1}login"
}

restart_services() {
    systemctl restart {ssh,sshd,dropbear,ws-stunnel,ws-dropbear} 2>/dev/null
}

# ==================== HELPER FUNCTIONS ====================
get_exp_date() {
    grep "### $1" "/etc/xray/ssh" | awk '{print $3}'
}

get_user_pass() {
    grep "### $1" "/etc/xray/ssh" | awk '{print $4}'
}

main