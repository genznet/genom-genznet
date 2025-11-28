#!/bin/bash

NC='\033[0m'
rbg='\033[41;37m'
r='\033[1;91m'
g='\033[1;92m'
y='\033[1;93m'
u='\033[0;35m'
c='\033[0;96m'
w='\033[1;97m'
q="\e[1;44;41m"

if [[ ! -f '/etc/.data' ]]; then
    echo -e "${y}File konfigurasi tidak ditemukan. Membuat file baru dengan default credential...${NC}"
    mkdir -p /etc
    cat <<EOF > /etc/.data
EMAILCF mailadmin@gmail.com
KEY 1b34d0f4661324dc63aa1c37e12ab8f765a2a
EOF
    echo -e "${g}File /etc/.data berhasil dibuat dengan credential default.${NC}"
    sleep 2
fi

EMAILCF=$(grep -w 'EMAILCF' '/etc/.data' | awk '{print $2}')
KEY=$(grep -w 'KEY' '/etc/.data' | awk '{print $2}')

# Contoh format emailcf dan key di dalam file /etc/.data :
# EMAILCF email_cfnya
# KEY api_tokennya


if [[ -z "$EMAILCF" || -z "$KEY" ]]; then
  echo -e "${r}Email dan api token tidak di temukan !!${NC}"
  exit 1
fi

add_akun_cf() {
    clear
    echo -e "${c}┌────────────────────────────────────┐${NC}"
    echo -e "${c}│${NC}     ${w}ADD AKUN CLOUDFLARE${NC}           ${c}│${NC}"
    echo -e "${c}└────────────────────────────────────┘${NC}"
    read -p "Masukkan Email Cloudflare: " input_email
    read -p "Masukkan API Token Cloudflare: " input_key

    if [[ -z "$input_email" || -z "$input_key" ]]; then
        echo -e "${r}Email atau API Token tidak boleh kosong!${NC}"
        sleep 2
        menu_wc
    fi

    cat <<EOF > /etc/.data
EMAILCF $input_email
KEY $input_key
EOF

    echo -e "${g}Akun Cloudflare berhasil ditambahkan.${NC}"
    sleep 2
    menu_wc
}

del_akun_cf() {
    clear
    echo -e "${c}┌────────────────────────────────────┐${NC}"
    echo -e "${c}│${NC}   ${r}DELETE AKUN CLOUDFLARE${NC}         ${c}│${NC}"
    echo -e "${c}└────────────────────────────────────┘${NC}"

    if [[ -f "/etc/.data" ]]; then
        rm -f /etc/.data
        echo -e "${g}Akun Cloudflare berhasil dihapus.${NC}"
    else
        echo -e "${r}File akun tidak ditemukan.${NC}"
    fi
    sleep 2
    menu_wc
}
get_account_id() {
    response=$(curl -s -X GET "https://api.cloudflare.com/client/v4/accounts" \
        -H "X-Auth-Email: $EMAILCF" \
        -H "X-Auth-Key: $KEY" \
        -H "Content-Type: application/json")

    if echo "$response" | jq -e '.success' >/dev/null 2>&1; then
        AKUNID=$(echo "$response" | jq -r '.result[0].id')
        #echo $AKUNID
    else
        echo -e "${r}Gagal mendapatkan Account ID${NC}"
        echo "$response" | jq
        exit 1
    fi
}

get_zone_id() {
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${EMAILCF}" \
     -H "X-Auth-Key: ${KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
}


function generate_random() {
WORKER_NAME="$(</dev/urandom tr -dc a-j0-9 | head -c4)-$(</dev/urandom tr -dc a-z0-9 | head -c8)-$(</dev/urandom tr -dc a-z0-9 | head -c5)"
}

buat_worker() {
    generate_random
    get_account_id

    WORKER_SCRIPT="
    addEventListener('fetch', event => {
        event.respondWith(handleRequest(event.request))
    })

    async function handleRequest(request) {
        return new Response('Hello World!', { status: 200 })
    }
    "
    
    URL="https://api.cloudflare.com/client/v4/accounts/$AKUNID/workers/scripts/$WORKER_NAME"
    response=$(curl -s -w "%{http_code}" -o response.json -X PUT \
        -H "X-Auth-Email: $EMAILCF" \
        -H "X-Auth-Key: $KEY" \
        -H "Content-Type: application/javascript" \
        --data "$WORKER_SCRIPT" \
        "$URL")

    httpCode=$(echo "$response" | tail -n1)
    body=$(cat response.json)

if [ "$httpCode" -eq 200 ]; then
echo "Succes. Name : $WORKER_NAME"
else
echo -e "${r}Gagal Membuat Worker '$WORKER_NAME':${NC}"
echo -e "${r}Status Code: $httpCode${NC}"
echo "$body"
fi

rm -f response.json
}

hapus_worker() {
    WORKER_NAME="${1}"
    get_account_id
    
    URL="https://api.cloudflare.com/client/v4/accounts/$AKUNID/workers/scripts/$WORKER_NAME"
    response=$(curl -s -w "%{http_code}" -o response.json -X DELETE -H "X-Auth-Email: $EMAILCF" -H "X-Auth-Key: $KEY" "$URL")

    httpCode=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$httpCode" -eq 200 ]; then
        echo -ne
    else
        echo -e "${r}Gagal menghapus Worker '$WORKER_NAME':${NC}"
        echo -e "${r}Status Code: $httpCode${NC}"
        echo "$body"
        exit 1
    fi
}

function pointing_cname() {
domain_sub="${1}"

DOMAIN=$(echo "$domain_sub" | cut -d "." -f2-)
SUB=$(echo "$domain_sub" | cut -d "." -f1)

SUB_DOMAIN="*.${SUB}.${DOMAIN}"

get_zone_id

RECORD_INFO=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${EMAILCF}" \
     -H "X-Auth-Key: ${KEY}" \
     -H "Content-Type: application/json")

RECORD=$(echo $RECORD_INFO | jq -r .result[0].id)
OLD_IP=$(echo $RECORD_INFO | jq -r .result[0].content)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${EMAILCF}" \
     -H "X-Auth-Key: ${KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"CNAME","name":"'${SUB_DOMAIN}'","content":"'${domain_sub}'","ttl":120,"proxied":false}' | jq -r .result.id)
else
     RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${EMAILCF}" \
     -H "X-Auth-Key: ${KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"CNAME","name":"'${SUB_DOMAIN}'","content":"'${domain_sub}'","ttl":120,"proxied":false}')
fi
}

function add_domain_worker() {
    get_account_id
    WORKER_NAME="${1}"
    CUSTOM_DOMAIN="${2}"

    DATA=$(cat <<EOF
{
    "hostname": "$CUSTOM_DOMAIN",
    "service": "$WORKER_NAME",
    "environment": "production"
}
EOF
    )

    RESPONSE=$(curl -s -w "%{http_code}" -o response.json \
        -X PUT "https://api.cloudflare.com/client/v4/accounts/$AKUNID/workers/domains/records" \
        -H "X-Auth-Email: $EMAILCF" \
        -H "X-Auth-Key: $KEY" \
        -H "Content-Type: application/json" \
        -d "$DATA")

    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

    if [ "$HTTP_CODE" -eq 200 ]; then
        echo -e "${c}Berhasil menambahkan domain $CUSTOM_DOMAIN ${NC}"
    else
        echo -e "${r}Gagal menambahkan domain. Kode error: $HTTP_CODE ${NC}"
        [ -f response.json ] && cat response.json
    fi

    [ -f response.json ] && rm -f response.json
}


function add_wc() {
echo -e "  ${c} Masukkan domain yg akan di pointing wildcard ( x untuk batal )${NC}"
input_domain() {
 read -p " Domain: " domain
 if [[ "${domain}" == "x" ]]; then
 echo -e "Proses di batalkan"
 exit 0
 elif [[ -z $domain ]]; then
  input_domain
 fi
}
input_domain
workername=$(buat_worker | grep -E "Succes" | awk '{print $4}')
pointing_cname ${domain}
data=($(cat /etc/.wc/bug.txt))
for bug in "${data[@]}"
do
add_domain_worker $workername ${bug}.${domain}
done
hapus_worker $workername
echo -e "${u} Enter Back To menu${NC}"
read
menu_wc
}

delete_wc_flow() {
    read -rp "Masukkan worker name yang ingin dihapus (contoh wc-...): " wn
    [[ -z "$wn" ]] && { echo "Dibatalkan"; return; }
    hapus_worker "$wn"
    read -rp "Tekan Enter untuk kembali ke menu..."
}

function menu_wc() {
clear
echo -e "${c}┌──────────────────────────────────────────┐${NC}"
echo -e "${c}│${NC}      ${u}.::. ${w}MENU POINTING WILDCARD${NC} ${u}.::.    ${c}│${NC}"
echo -e "${c}└──────────────────────────────────────────┘${NC}"
echo -e "${c}│$NC 1.)${y}☞ ${w} Add Akun Cloudflare${NC}"
echo -e "${c}│$NC 2.)${y}☞ ${w} Delete Akun Cloudflare${NC}"
echo -e "${c}│$NC 3.)${y}☞ ${w} Add Wildcard${NC}"
echo -e "${c}│$NC 4.)${y}☞ ${w} Delete Wildcard${NC}"
echo -e "${c}│$NC 5.)${y}☞ ${w} Add or edit bug Wildcard${NC}"
echo -e "${c}│$NC x.)${y}☞ ${r} Exit${NC}"
echo -e "${c}└──────────────────────────────────────────┘${NC}"
echo
read -p " Select Options [ 1 - 5 or x ] " opt
case $opt in
01 | 1) clear ; add_akun_cf ;;
02 | 2) clear ; del_akun_cf ;;
03 | 3) clear ; add_wc ;;
04 | 4) clear ; delete_wc_flow ;;
05 | 5) clear
mkdir -p "/etc/.wc"
    touch "/etc/.wc/bug.txt"
    chmod 600 "/etc/.wc/bug.txt"
    echo -e "${c}Edit file bug list: /etc/.wc/bug.txt${NC}"
    echo -e "${y}Masukkan satu bug per baris (tanpa spasi). Simpan & keluar untuk lanjut.${NC}"
    ${EDITOR:-nano} "/etc/.wc/bug.txt"
echo -e " Success"
sleep 2
menu_wc
;;
x | X) exit 0 ;;
*) clear ; $0 ;;
esac
}

if [[ "${1}" == "buat_worker" ]]; then
buat_worker
elif [[ "${1}" == "hapus_worker" ]]; then
hapus_worker "${2}"
elif [[ "${1}" == "add_domain_worker" ]]; then
  if [[ -z "${2}" || -z "${3}" ]]; then
  echo "Usage:
  $0 $1 worker_name custom_domain"
  exit 1
  else
  add_domain_worker "${2}" "${3}"
  fi
elif [[ "${1}" == "pointing_cname" ]]; then
pointing_cname "${2}"
else
menu_wc
fi
