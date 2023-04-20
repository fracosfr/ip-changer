# Configuration file

## Description
The configuration file contains all the IP Changer instructions.

Configuration files are simple ini files with the extension `.ipcg`, you can edit them with notepad or your favorite text editor.

> Configuration files must start with `# IP CHANGER CONFIG FILE` in the first line.

## Sections
| NAME      | DESCRIPTION                       |                               |
|-----------|-----------------------------------|-------------------------------
| interface | Network interface configuration   | **REQUIRED**
| static    | Static IP informations            | Required only if `mode=static`
| dns       | DNS server configuration          | *optional*
| driver    | Chose between Powershell or netsh | *optional*
| proxy     | Configure the proxy               | *optional*
| gui       | Define the quiet mode             | *optional*

## Interface section
| Param | Function | Values | Default |
|---|---|---|---|
|

## Static section
| Param | Function | Values | Default |
|---|---|---|---|
|

## DNS section
| Param | Function | Values | Default |
|---|---|---|---|
|

## Driver section
| Param | Function | Values | Default |
|---|---|---|---|
|

## Proxy section
| Param | Function | Values | Default |
|---|---|---|---|
|


## Gui section
| Param | Function | Values | Default |
|---|---|---|---|
| mode | Set the verbose mode | `alert`, `quiet` | `alert`|

- quiet : IP Changer does not send any messages or alerts.
- alert : IP Changer displays an alert dialog box in case of success or error

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