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
