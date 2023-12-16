# Configuration
$country = ''  # empty for any or JP, KR, US, TH, etc.
$useSavedVPNlist = 0  # set to 1 if you don't want to download VPN list every time you restart this script, otherwise set to 0
$useFirstServer = 0  # set the value to 0 to choose a random VPN server, otherwise set to 1 (maybe the first one has a higher score)
$vpnList = 'C:\Temp\vpns.txt'
$proxy = 0  # replace with 1 if you want to connect to VPN server through a proxy
$proxyIP = ''
$proxyPort = 8080
$proxyType = 'socks'  # socks or http

# Logging function
function Log {
    param($message)
    Add-Content -Path 'C:\Temp\VPNLOG.log' -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
}

# ... (unchanged functions)

function DownloadVPNList {
    Log 'Отримання списку VPN.'
    Invoke-RestMethod -Uri 'https://www.vpngate.net/api/iphone/' -OutFile $vpnList
}

# ... (unchanged functions)

function StartOpenVPN {
    Log 'Спроба запустити клієнт OpenVPN.'

    # Check if OpenVPN is installed
    if (Test-Path 'C:\Program Files\OpenVPN\bin\openvpn.exe') {
        Start-Process 'C:\Program Files\OpenVPN\bin\openvpn.exe' -ArgumentList "--config C:\Temp\openvpn3"
    } else {
        Log 'OpenVPN не знайдено. Встановіть OpenVPN перед використанням цього скрипта.'
        exit 1
    }
}

# ... (unchanged functions)

while ($true) {
    DownloadVPNList

    if ((Get-Content $vpnList | Measure-Object -Line).Lines -eq 0) {
        HandleError 'Не вдалося отримати список VPN або список порожній.'
    }

    $counter = 0
    $array = Get-Content $vpnList | Where-Object {$_ -match ",$country"}
    $counter = $array.Count

    if ($counter -eq 0) {
        HandleError 'Не знайдено жодних серверів VPN з обраної країни.'
    }

    CreateVPNConfig
    StartOpenVPN

    $confirm = Read-Host 'Спробувати інший сервер VPN? (Y/N)'
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        exit
    }
}