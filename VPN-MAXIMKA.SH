#!/bin/bash
 

 
# you can change these parameters:
country='' # empty for any or JP, KR, US, TH, etc.
useSavedVPNlist=0 # set to 1 if you don't want to download VPN list every time you restart this script, otherwise set to 0
useFirstServer=0 # set the value to 0 to choose a random VPN server, otherwise set to 1 (maybe the first one has higher score)
vpnList='/tmp/vpns.tmp'
proxy=0 # replace with 1 if you want to connect to VPN server through a proxy
proxyIP=''
proxyPort=8080
proxyType='socks' # socks or http,socks4,socks5
proxyUsername='your_proxy_username' # optional, set to an empty string if not required
proxyPassword='your_proxy_password' # optional, set to an empty string if not required

# don't change this:
counter=0
VPNproxyString=''
cURLproxyString=''
GREEN='\033[0;32m' # код ANSI для зеленого цвета
NC='\033[0m'      # код ANSI для сброса цвета
SPIN_CHARS="/-\|"

show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -c, --country COUNTRY   Set the country for VPN servers (e.g., JP, KR, US)"
    echo "  -u, --useSavedVPNlist   Set to 1 if you don't want to download VPN list every time you restart"
    echo "  -f, --useFirstServer    Set the value to 0 to choose a random VPN server, otherwise set to 1"
    echo "  -P, --proxy             Set to 1 if you want to connect to VPN server through a proxy"
    echo "  -pIP, --proxyIP         Set the proxy IP address"
    echo "  -p, --proxyPort         Set the proxy port"
    echo "  -pT, --proxyType        Set the proxy type (socks or http,socks4,socks5)"
    echo "  -pN, --proxyUsername    Set the proxy username (optional; leave empty if not required)"
    echo "  -pP, --proxyPassword    Set the proxy password (optional; leave empty if not required)"
    echo "  -h, --help              Show this help message"
    exit 0
}



# Задайте аргументы командной строки
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -c|--country)
            country="$2"
            shift
            ;;
        -u|--useSavedVPNlist)
            useSavedVPNlist="$2"
            shift
            ;;
        -f|--useFirstServer)
            useFirstServer="$2"
            shift
            ;;
        -P|--proxy)
            proxy="$2"
            shift
            ;;
        -pIP|--proxyIP)
            proxyIP="$2"
            shift
            ;;
        -p|--proxyPort)
            proxyPort="$2"
            shift
            ;;
        -pT|--proxyType)
            proxyType="$2"
            shift
            ;;
        -h|--help)
            show_help
            ;;
        -pN|--proxyUsername)
            proxyUsername="$2"
            shift
            ;;
        -pP|--proxyPassword ) 
            proxyPassword="$2"
            shift
            ;;
        *)
            echo "Неизвестный параметр: $key"
            exit 1
            ;;
    esac
    shift
done
#что сверху это конвиг  снизу код 

#!/bin/bash




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
