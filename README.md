# ip-changer
This is a little program that allow change IP configuration on Windows 10/11 with a pre-defined configuration file.

## How to install
This script does not require installation, you can copy it on your drive and just run it with a configuration file in parameter

```bash
ip_changer.exe my_config_file.ipcg
```

Tips: You can define the *.ipcg extension default program with ip_config.exe to execute automatiquely the program by double click on the config file.

## Edit a configuration file
The ip changer configuration files are ini file with ipcg extension, you can open it with notepad or your favorite text editor.

## Configuration file 
The firs line of the configuration file must be `# IP CHANGER CONFIG FILE`.

### [interface] section
The section interface (needed) describe the Network interface and the running mode.
```ini
[interface]
name=Ethernet
mode=STATIC
```
The name of the interface must be the same than the network adapter to use.

You can set the mode with :
- `ON` -> Active the network interface.
- `OFF` -> disable the network interface.
- `STATIC` -> enable and set the ip configuration described in the `[static]` section.
- `DHCP` -> enable and set the ip configuration on DHCP (automatic ip).

### [static] section
This section must be filled is you define the interface mode on `STATIC`.
```ini
[static]
ip=192.168.2.10
gateway=192.168.2.1
# net mask (default : 24 if powershell or 255.255.255.0)
mask=24
```
The ip parameter must be an IPV4 address.

The gateway must be a valid IPV4 gateway, but if dont set the default gateway will be `x.y.z.1` where x.y.z is the start of the ip address configured.

The mask parameter must be :
- a valid IPV4 address if you dont use the powershell driver *(eg: 255.255.255.0)*.
- the network prefix length if you use the powershell driver *(eg: 24)*.

### [dns] section
The DNS configuration is facultative.
```ini
[dns] 
primary=8.8.8.8
secondary=8.8.4.4
```
The dns address must be a valid IPV4 address.

### [driver] section
You can chose if you want work with the Powershall driver or the netsh driver *(deprecated)*.
```ini
[driver]
powershell=Yes
```
Value must be `Yes` or `No`, by default is `Yes`.

### [proxy] section
Facultative, you can set a proxy configuration.
```ini
[proxy]
server=1.2.3.4
port=9876
override=123.123.123.123;123.123.123.124
overrideLocal=Yes
script=monscript.sh
```
The server must be a valid IPV4 address, the port and the server are needed.

You can use the override option with IPV4 address separated with semicolon *(dont miss to set the `overrideLocal` to `Yes`)*.

If you want to use an install proxy script, set the path in the `script` parameter.

## Configuration file example
```ini
# IP CHANGER CONFIG FILE
[interface]
name=Ethernet
mode=STATIC

[static]
ip=192.168.2.10
mask=24
gateway=192.168.2.1

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
## Download
You can downlod the lastest version on this page : https://github.com/fracosfr/ip-changer/releases
