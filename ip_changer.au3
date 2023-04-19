#NoTrayIcon

#RequireAdmin

#include <MsgBoxConstants.au3>

global $FILECONFIG = ""



if $CmdLine[0] == 1 Then
	ConsoleWrite($CmdLine)
	$FILECONFIG = $CmdLine[1]
EndIf

if $FILECONFIG == "" Then
	printError("Aucun fichier de configuration spécifié !")
	Exit
EndIf

if not FileExists($FILECONFIG) Then
	printError("Fichier de configuration introuvable !")
	Exit
EndIf

if FileReadLine($FILECONFIG) <> "# IP CHANGER CONFIG FILE" Then
	printError("Fichier de configuration invalide !")
	Exit
EndIf

global $INTERFACE = IniRead($FILECONFIG, "interface", "name", "")
global $MODE = IniRead($FILECONFIG, "interface", "mode", "")
global $POWERSHELL = IniRead($FILECONFIG, "driver", "powershell", "Yes")

if $INTERFACE == "" or $MODE == "" Then
	printError("Fichier de configuration incomplet !")
	Exit
EndIf

if $MODE == "OFF" Then
	setOff()
	printInfo("La carte "&$INTERFACE&" a bien été désactivée !")
	Exit
EndIf

if $MODE == "ON" Then
	setOn()
	printInfo("La carte "&$INTERFACE&" a bien été activée !")
	Exit
EndIf

if $MODE == "DHCP" Then
	setDhcp()
	printInfo("La carte "&$INTERFACE&" a été configurée en mode DHCP !")
	Exit
EndIf

if $MODE == "STATIC" Then
	
	$ip = IniRead($FILECONFIG, "static", "ip", "")
	$mask = IniRead($FILECONFIG, "static", "mask", "24")
	if $POWERSHELL <> "Yes" and $mask == "24" Then
		$mask = "255.255.255.0"
	EndIf
	
	$gateway = IniRead($FILECONFIG, "static", "gateway", "")
	
	
	if $ip == "" Then
		printError("Une adresse IP doit étre spécifiée !")
		Exit
	EndIf
	
	$ar_ip = StringSplit($ip, ".")
	if $ar_ip[0] <> 4 Then
		printError("L'adresse ip spécifiée n'est pas valide !")
		Exit
	EndIf
	
	
	
	if $gateway == "" Then
		$gateway =  $ar_ip[1] & "." &  $ar_ip[2] & "." &  $ar_ip[3] & ".1"
	EndIf
	

	setOn()
	
	if $POWERSHELL == "Yes" Then
		powershell("Get-NetIPAddress -InterfaceAlias """&$INTERFACE&""" | Remove-NetIPAddress -Confirm:$False")
		powershell("New-NetIPAddress -InterfaceAlias """&$INTERFACE&""" -IPAddress "&$ip&" -PrefixLength "&$mask&" -DefaultGateway "&$gateway&" -AddressFamily IPv4 -Confirm:$False")
	Else
		RunWait(@ComSpec & " /c " & 'netsh interface ip set address "'&$INTERFACE&'" static '&$ip&" "&$mask&" "& $gateway, '', @SW_HIDE)
	EndIf
	
	setDns()
	setProxy()
	setOff()
	setOn()
	
	printInfo("La carte "&$INTERFACE&" a été configurée avec l'adresse IP statique "&$ip&" !")
	Exit
EndIf



func powershell($command)
	RunWait(@ComSpec&" /c powershell -WindowStyle Hidden " & $command, "", @SW_HIDE)	
EndFunc



func setDhcp()
	
	
	setOn()
	if $POWERSHELL == "Yes" Then
		powershell("Set-DnsClientServerAddress -InterfaceAlias """&$INTERFACE&""" -ResetServerAddresses -Confirm:$False")
		powershell("Get-NetIPAddress -InterfaceAlias """&$INTERFACE&""" | Remove-NetIPAddress -Confirm:$False")
		powershell("Set-NetIPInterface -InterfaceAlias """&$INTERFACE&""" -Dhcp Enabled")
	Else
		RunWait(@ComSpec & " /c " & 'netsh interface ip set dnsservers "'&$INTERFACE&'"  source=dhcp', '', @SW_HIDE)
		RunWait(@ComSpec & " /c " & 'netsh interface ip set address "'&$INTERFACE&'" dhcp', '', @SW_HIDE)
	EndIf
	setDns()
	setProxy()
	setOff()
	setOn()
	
EndFunc

func setDns()
	
	$dns1 = IniRead($FILECONFIG, "dns", "primary", "")
	$dns2 = IniRead($FILECONFIG, "dns", "secondary", "")
	
	if $POWERSHELL == "Yes" Then
		if $dns1 <> "" Then
			$dnsList = $dns1
			if $dns2 <> "" Then
				$dnsList = $dns1&", "&$dns2
			EndIf
			powershell("Set-DnsClientServerAddress -InterfaceAlias """&$INTERFACE&""" -ServerAddresses "&$dnsList&" -Confirm:$False")
		EndIf
	Else
		if $dns1 <> "" Then
			;RunWait(@ComSpec & " /c " & 'netsh interface ipv4 set dnsservers "'&$INTERFACE&'" source=static address='&$dns1&' primary', '', @SW_HIDE)
			RunWait(@ComSpec & " /c " & 'netsh interface ipv4 add dnsservers "'&$INTERFACE&'" '&$dns1&' index=1', '', @SW_HIDE)
			if $dns2 <> "" Then
				RunWait(@ComSpec & " /c " & 'netsh interface ipv4 add dnsservers "'&$INTERFACE&'" '&$dns2&' index=2', '', @SW_HIDE)
			EndIf
		EndIf
		
	EndIf
EndFunc

func setProxy()
	
	$server = IniRead($FILECONFIG, "proxy", "server", "")
	$port = IniRead($FILECONFIG, "proxy", "port", "")
	$disable = IniRead($FILECONFIG, "proxy", "port", "No")
	
	if $server <> "" and $port <> "" Then
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD", 1)
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer", "REG_SZ", $server&":"&$port)
		
		$override = IniRead($FILECONFIG, "proxy", "override", "")
		if  IniRead($FILECONFIG, "proxy", "overrideLocal", "No") == "Yes" Then
			if $override <> "" Then
				$override = $override & ";"
			EndIf
			$override = $override & "<local>"
		EndIf
		if $override <> "" Then
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride", "REG_SZ", $override)
		EndIf
		
		
		
		
	Else
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD", 0)
	EndIf
	
	$script = IniRead($FILECONFIG, "proxy", "script", "")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings", "AutoConfigURL", "REG_SZ", $script)
	
EndFunc


func setOn()
	if $POWERSHELL == "Yes" Then
		powershell("Enable-NetAdapter -Name """&$INTERFACE&"""" )
	Else
		RunWait(@ComSpec & " /c " & 'netsh int set int name="'&$INTERFACE&'" admin=enabled', '', @SW_HIDE)
	EndIf
EndFunc

func setOff()
	if $POWERSHELL == "Yes" Then
		powershell("Disable-NetAdapter -Name """&$INTERFACE&""" -Confirm:$False")
	Else
		RunWait(@ComSpec & " /c " & 'netsh int set int name="'&$INTERFACE&'" admin=disabled', '', @SW_HIDE)
	EndIf
EndFunc

func printError($message)
	MsgBox($MB_ICONERROR +  $MB_OK, translate("msg_box_title", "error", "ERROR!"), $message)
EndFunc

func printInfo($message, $title = translate("msg_box_title", "done", "DONE!"))
	MsgBox($MB_ICONINFORMATION +  $MB_OK, $title, $message)
EndFunc

func translate($section, $key, $default)
	$appFileConfig = "config.ini"
	if not FileExists($appFileConfig) Then
		Return $default
	EndIf

	$language = IniRead($appFileConfig, "locale", "language", "")

	if $language == "" Then
		Return $default
	EndIf

	$languageFile = "locale/" & $language & ".ini"

	if not FileExists($languageFile)  Then
		Return $default
	EndIf

	Return IniRead($languageFile, $section, $key, $default)
EndFunc