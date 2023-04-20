# Languages
IP Changer supports multilanguage, you can create your own language file or use a language file present in the repository.

Language files are ini files, it is necessary to respect the ini syntax.

## Default language
IP Changer has been compiled with the default English language, no additional files are needed.

## Set the language
To setup a language, you need to create a "local" directory in the same directory as the "ip_changer.exe" executable.

Put a language file *(for example: FR.ini)* in the `locale` folder and open the `config.ini` file.
If the 'config.ini' file does not exist, make it next to the 'locale' folder.

- :file_folder:/
  - :file_folder:locale/
    - :hammer_and_wrench:FR.ini
  - :hammer_and_wrench:config.ini
  - :gear:ip_changer.exe

In the `config.ini` file, set the language parameter in the local section:
 ```ini
[locale]
language=FR
 ```

 ## Default language values
By default, if the language file does not exist or if the config file does not exist, IP Changer is in English.

The texts are defined below *(You can use it to create a new language file)*:
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