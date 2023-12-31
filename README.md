# VPN-MAXIMKA.V.04.stable

VPN-MAXIMKA - is a Bash script that simplifies the process of connecting to VPN servers using OpenVPN. It provides flexibility to choose servers based on location, use saved VPN lists, and optionally

## Copyright

© 12/15/2023 Maxim Bely

This project is protected by copyright. Any unauthorized use, copying or distribution without the permission of the author may constitute a violation of copyright.

## Disclaimer

**Please note that the use of this script is at your own risk. The author assumes no responsibility for any consequences arising from its use.**

This script is provided "as is," without any warranty, express or implied. The author makes no guarantees regarding its functionality or suitability for any specific purpose. Users are encouraged to review and modify the script according to their requirements and to exercise caution when working with network-related tools.

Use this script responsibly, and ensure compliance with the terms of service of any services or APIs it interacts with. The author is not liable for any damages or issues that may arise from the use of this script.

---

**Note:** Always respect legal and ethical considerations, and make sure you have the necessary permissions to use network-related tools and services.

### Prerequisites

- Ensure that you have Bash installed on your system.
- Make sure you have OpenVPN
- Make sure you have the necessary permissions to run the script with sudo.

### Configuration

## Configuration

You can customize the behavior of the script by modifying the parameters in the script itself:

- **country:** Set the desired country code for VPN servers. Leave it empty for any country or specify JP, KR, US, TH, etc.
- **useSavedVPNlist:** Set to 1 if you want to use a saved VPN list instead of downloading it every time you run the script.
- **useFirstServer:** Set to 1 to always choose the first VPN server from the list.
- **proxy:** Set to 1 if you want to connect to the VPN server through a proxy.
- **proxyIP, proxyPort, proxyType:** Configure proxy settings if ***proxy*** is set to 1.
- **proxyUsername, proxyPassword:** Set the proxy username and password if required (leave empty if not needed).

## Technologies

The script utilizes the following technologies and features:

- **Bash (Bourne Again SHell):** The scripting language used for the main implementation.
- **cURL:** Used for downloading the VPN server list.
- **awk:** Used for text processing to extract information from the server list.
- **Base64:** Used for decoding Base64-encoded server details.
- **OpenVPN:** The VPN client used for establishing the connection.
- **Proxy (SOCKS, HTTP):** Optional feature to connect to the VPN server through a proxy.
- **ANSI Escape Codes:** Used for colorizing terminal output.
- **Loops (while, for):** Used for iterative tasks and waiting periods.
- **Functions:** Segmented code into functions for better organization.
- **Conditional Statements:** Used for decision-making based on user input.
- **Bash Arrays:** Used to store and manage VPN server details.
- **User Input:** Accepts user input to customize script behavior.





### Running the Script
```bash
git clone https://github.com/RubyCat1337/VPN-MAXIMKA.git
chmod +x vpn-maximka.sh
./vpn-maximka.sh --help

./vpn-maximka.sh -c JP -u 0 -f 0 -P 1 -pIP your_proxy_ip -pPort 8080 -pType socks -pN your_username -pP your_password 
