# Configuration file

## Description
The configuration file contains all the IP Changer instructions.

Configuration files are simple ini files with the extension `.ipcg`, you can edit them with notepad or your favorite text editor.

> Configuration files must start with `# IP CHANGER CONFIG FILE` in the first line.

## Sections
| NAME      | DESCRIPTION                       |                               |
|-----------|-----------------------------------|-------------------------------
| interface | Network interface configuration   | **REQUIRED**
| static    | Static IP informations            | Required only if mode=`STATIC`
| dns       | DNS server configuration          | *optional*
| driver    | Chose between Powershell or netsh | *optional*
| proxy     | Configure the proxy               | *optional*
| gui       | Define the quiet mode             | *optional*

## Interface section
| Param | Function | Values | Default |
|---|---|---|---|
|name | Ethernet interface name | Interface name, must be identical to Windows | **REQUIRED**
| mode | operating mode | `ON`, `OFF`, `DHCP`, `STATIC` | **REQUIRED**

## Static section
| Param | Function | Values | Default |
|---|---|---|---|
|ip | Static IPv4 address | Ipv4 address | **REQUIRED**
|masq | Network mask | CIDR if Powershell driver, otherwise IPv4 address | 24 *(255.255.255.0)*
| gateway | Gateway | Ipv4 address | x.x.x.1

## DNS section
| Param | Function | Values | Default |
|---|---|---|---|
| primary | Primary DNS server | IPv4 address, must be specified if the secondary server is not empty | *empty*
| secondary | Secondary DNS serveur | IPv4 address | *empty*

## Driver section
| Param | Function | Values | Default |
|---|---|---|---|
|powershell| Enable powershell driver, otherwise netsh is used | `Yes`, `No` | `Yes`

## Proxy section
| Param | Function | Values | Default |
|---|---|---|---|
| server | Proxy server | IP address or server address | *empty*
| port | Proxy port | port number | *empty*, required if server specified
| override | IPv4 addresses not passing through the proxy| IPv4 Address list, separated by a comma| *empty*
| overrideLocal | Do not use proxy server for local addresses | `Yes`, `No` | `No`
| script | Install script | path to the script file | *empty*

## Gui section
| Param | Function | Values | Default |
|---|---|---|---|
| mode | Set the verbose mode | `alert`, `quiet` | `alert`|

- quiet : IP Changer does not send any messages or alerts.
- alert : IP Changer displays an alert dialog box in case of success or error

> TIP: You can add "quiet" as the second parameter when running IP change
> `ip_changer.exe your_config_file.ipcg quiet`

## Configuration file example
```ini
# IP CHANGER CONFIG FILE

[interface]
name=Ethernet
mode=STATIC

[static]
ip=192.168.2.10
mask=24

[dns] 
primary=8.8.8.8
secondary=8.8.4.4

[driver]
powershell=Yes

[proxy]
server=1.2.3.4
port=9876
override=123.123.123.123;123.123.123.124
overrideLocal=Yes
script=monscript.sh
```
