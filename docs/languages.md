# Languages
IP Changer support multilanguage, you can create your language file or use a language file present in the repository.

The language files are ini file, you must respect the ini syntax.

## Default language
IP Changer was compiled with the English language by default, no extra file is needed.

## Set the language
To setup an language, you must create a `locale` folder in the same directory than the `ip_changer.exe` executable.

Put in the `locale` folder a language file *(eg: FR.ini)* then open the `config.ini` file.
If the `config.ini` file does not exist, create it near the `locale` folder.

- :file_folder:/
  - :file_folder:locale/
    - :hammer_and_wrench:FR.ini
  - :hammer_and_wrench:config.ini
  - :gear:ip_changer.exe

In the `config.ini` file set the language parameter in the locale section :
 ```ini
[locale]
language=FR
 ```

 ## Default language values
By default, if the language file does not exist or if the config file does not exist, IP Changer is in English.

The texts are defined below *(You can use this for create new language file)*:
```ini
[msg_box_title]
error=ERROR
done=Done

[errors]
no_file=No config file specified!
not_found=Config file not found!
invalid=Invalid config file!
partial=Not complete config file!
ip_invalid=Invalid IP address!
ip_not_found=An IP address must be specified!

[success]
on=The {interface} interface has been activated.
off=The {interface} interface has been deactivated.
dhcp=The {interface} interface has been configured on DHCP mode.
static=The {interface} interface has been configured on STATIC mode with ip {ip}.
```