

#!/bin/bash

source options.SH


# Load configuration from a separate file

# Logging function
download_vpn_list() {
  log "Отримання списку VPN."
  if [ $proxy -eq 1 ]; then
    cURLproxyString="--proxy $proxyType://$proxyIP:$proxyPort"
    if [ -n "$proxyUsername" ] && [ -n "$proxyPassword" ]; then
      cURLproxyString="$cURLproxyString --proxy-user $proxyUsername:$proxyPassword"
    fi
  fi
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




while true; do
  # Download VPN list only if useSavedVPNlist is set to 0
  if [ $useSavedVPNlist -eq 0 ]; then
    echo -e "\033[0;32mСкоро впн запустится\033[0m\ \033[0;31mИдет скачевания Впн листа.\033[0m "
    echo -n "Обработка: "  # Prints the initial message without a newline
	for i in {1..20}; do
  		echo -n -e "\b\033[32m${SPIN_CHARS:i%${#SPIN_CHARS}:1}"
  		sleep 0.4
	done
	echo -e "\033[0m"
    download_vpn_list

    if [ ! -s $vpnList ]; then
      handle_error 'Не вдалося отримати списку VPN або список порожній.'
    fi
  fi

  counter=0
  echo -e "\033[0;32mСкоро впн запустится\033[0m"
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
