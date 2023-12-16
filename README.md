# VPN-MAXIMKA.V.02.stable

VPN-MAXIMKA.V.02.stable is a bash script designed to facilitate VPN connections by retrieving a list of VPN servers and connecting to a randomly selected server from a specified country.

## Usage

### Prerequisites

- Ensure that you have Bash installed on your system.
- Make sure you have the necessary permissions to run the script with sudo.

### Configuration

You can customize the behavior of the script by modifying the parameters in the script itself:

- `country`: Set the desired country code for VPN servers. Leave it empty for any country or specify JP, KR, US, TH, etc.
- `useSavedVPNlist`: Set to 1 if you want to use a saved VPN list instead of downloading it every time you run the script.
- `useFirstServer`: Set to 1 to always choose the first VPN server from the list.
- `proxy`: Set to 1 if you want to connect to the VPN server through a proxy.
- `proxyIP`, `proxyPort`, `proxyType`: Configure proxy settings if `proxy` is set to 1.

### Running the Script
```bash
git clone https://github.com/RubyCat1337/VPN-MAXIMKA.git
chmod +x vpn-maximka.sh
./vpn-maximka.sh

