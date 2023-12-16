#!/bin/bash
 

 
# you can change these parameters:
country='' # empty for any or JP, KR, US, TH, etc.
useSavedVPNlist=0 # set to 1 if you don't want to download VPN list every time you restart this script, otherwise set to 0
useFirstServer=0 # set the value to 0 to choose a random VPN server, otherwise set to 1 (maybe the first one has higher score)
vpnList='/tmp/vpns.tmp'
proxy=0 # replace with 1 if you want to connect to VPN server through a proxy
proxyIP=''
proxyPort=8080
proxyType='socks' # socks or http
 
# don't change this:
counter=0
VPNproxyString=''
cURLproxyString=''
GREEN='\033[0;32m' # код ANSI для зеленого цвета
NC='\033[0m'      # код ANSI для сброса цвета
SPIN_CHARS="/-\|"
#что сверху это конвиг  снизу код 

#!/bin/bash




# Load configuration from a separate file

# Logging function
download_vpn_list() {
  log "Отримання списку VPN."
  curl -s $cURLproxyString https://www.vpngate.net/api/iphone/ > $vpnList
}

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> VPNLOG.log
}


create_vpn_config() {
  if [ -z "${array[0]}" ]; then
    log 'Не знайдено жодних серверів VPN з обраної країни.'
    exit 1
  fi

  size=${#array[@]}

  if [ $useFirstServer -eq 1 ]; then
    index=0
    log "Використовуючи перший сервер VPN."
  else
    index=$((RANDOM % size))
    log "Вибір випадкового сервера VPN. Обраний індекс: $index"
  fi

  echo ${array[$index]} | awk -F "," '{ print $15 }' | base64 -d > /tmp/openvpn3
  log "Деталі обраного сервера VPN: ${array[$index]}"
}

start_openvpn() {
  log 'Спроба запустити клієнт OpenVPN.'

  # Check if sudo is available
  if command -v sudo >/dev/null 2>&1; then
    sudo openvpn --config /tmp/openvpn3 $VPNproxyString
  else
    log 'У вас немає sudo. Запустіть скрипт від імені адміністратора.'
    exit 1
  fi
}

echo -e "\033[0;32mСкоро впн запустится\033[0m\ \033[0;31mИдет скачевания Впн листа.\033[0m "

echo -n "Обработка: "  # Prints the initial message without a newline
for i in {1..20}; do  # Outer loop runs 10 times
    for char in ${SPIN_CHARS}; do  # Inner loop iterates over characters in the variable SPIN_CHARS
        echo -ne "\b\033[32m${char}"  # Prints the current character without a newline, using \r to overwrite the previous output
        sleep 0.4  # Pauses for 0.1 seconds to create the animation effect
    done
done

echo -e "\033[0m"

handle_error() {
  log "Помилка: $1"
  exit 1
}

# ... (unchanged functions)

while true; do
  download_vpn_list

  if [ ! -s $vpnList ]; then
    handle_error 'Не вдалося отримати списку VPN або список порожній.'
  fi

  counter=0
  while read -r line; do
    array[$counter]="$line"
    ((counter++))
  done < <(grep -E ",$country" $vpnList)

  if [ $counter -eq 0 ]; then
    handle_error 'Не знайдено жодних серверів VPN з обраної країни.'
  fi

  create_vpn_config
  start_openvpn

  read -p "Спробувати інший сервер VPN? (Y/N): " confirm
  [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit
done
