@echo OFF
setlocal
%SystemRoot%\System32\rundll32.exe shell32.dll,SHCreateLocalServerRunDll {c82192ee-6cb5-4bc0-9ef0-fb818773790a}
CLS
MD %USERPROFILE%\AppData\Local\Temp\AIO
echo. > %USERPROFILE%\AppData\Local\Temp\AIO\log.txt

::========================================================================================================================================
::========================================================================================================================================

cls
:SelfAdminTest
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:init
setlocal DisableDelayedExpansion
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::========================================================================================================================================
::========================================================================================================================================

:MainMenu
cls
title  AIO TOOLBOX ARIA VERSION
mode con cols=80 lines=15
Set "Path=%Path%;%cd%;%cd%\files"
Color 0a

:Main
Cls
Echo.
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
Echo.
CmdMenuSel 0Ab1 "   [1] System Information Gathering" "   [2] COMPUTER CONFIGURATION" "   [3] UPDATER" "   [4] CLEANER" "   [5] WINDOWS INSTALL (WORK IN PROGRESS)" "   [6] EXTRAS" "   [7] SHUTDOWN OPTIONS" "   [8] EXIT"
if errorlevel  8 goto:EXIT
if errorlevel  7 goto:SHUTDOWN_OPTIONS
if errorlevel  6 goto:EXTRAS
if errorlevel  5 goto:WIN_INSTALL
if errorlevel  4 goto:CLEANER
if errorlevel  3 goto:UPDATER
if errorlevel  2 goto:COMPUTER_CONFIGURATION
if errorlevel  1 goto:INFORMATION
Cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
::========================================================================================================================================

:INFORMATION
CLS
Title SYSTEM INFO
mode con cols=98 lines=15
ECHO:
ECHO                      HERE IS 2 POSSIBLE METHODS OF DISPLAYING DEVICE INFORMATION
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
Echo.
CmdMenuSel 0Ab1 "   [1] QUICK INFORMATION CONFIGURATION" "   [2] HWINFO32 THIRD PARTY APPLICATION" "   [3] GO TO PREVIOUS MENU" "   [4] EXIT"
if errorlevel  4 goto:exit
if errorlevel  3 goto:end_BACKMENU
if errorlevel  2 goto:HWINFO32
if errorlevel  1 goto:QUICK_INFO
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls
::========================================================================================================================================

:QUICK_INFO
cls
TITLE QUICK INFO
echo THIS WILL CREATE A INFORMATIONAL PRINTOUT OF YOUR COMPUTER CONFIGURATION
rem testing enviromental methods of saving items due to microsoft accounts with spaces and special characters giving issues to the script
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/ComputerInfo.ps1 -d, --dir=C:\AIO\ --allow-overwrite="true" --disable-ipv6
Powershell -ExecutionPolicy Bypass -File "C:\AIO\ComputerInfo.ps1"  -verb runas
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Operation completed successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
start /wait C:\AIO\Basic-Computer-Information-Report.html
timeout 2 >nul
goto end_BACKMENU


::========================================================================================================================================

:HWINFO32
cls
TITLE HWINFO32 THIRD PARTY APPLICATION
echo THIS WILL LOAD AN THIRD PARTY APPLICATION TO PREVIEW USEFULL INFORMATION
echo ABOUT YOUR DEVICE AND SYSTEM RECOURSES
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/HWiNFO32.exe -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/HWiNFO32.INI -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
start /wait C:\AIO\HWiNFO32.exe
timeout 2 >nul
pause & cls & GOTO TEST_CONNECTION

::========================================================================================================================================

:TEST_CONNECTION
color 0f
mode con cols=98 lines=60
cls
title LIST OF NETWORK CONFIGURATION
echo This section will display a list of all network configurations registered on the device. > c:\AIO\log.txt
ECHO:
Echo %Date% %Time% >> %USERPROFILE%\AppData\Local\Temp\AIO\log.txt
ECHO:
netsh interface ip show config
netsh interface ip show config >> %USERPROFILE%\AppData\Local\Temp\AIO\log.txt
pause & GOTO end_BACKMENU

::========================================================================================================================================
::========================================================================================================================================

:COMPUTER_CONFIGURATION
cls
title COMPUTER_CONFIGURATION
mode con cols=98 lines=32
echo:
echo                       Press the corresponding number to go to desired section:
echo:
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
Echo.
CmdMenuSel 0Ab1 "   [1] NETWORK SETUP" "   [2] DEFENDER TOOLBOX" "   [3] MICROSOFT ACTIVATION" "   [4] TELEMETRY" "   [5] Disable Specific Services" "   [6] BACKUPPER" "   [7] SHUTDOWN OPTIONS" "   [8] BACK"  "   [8] EXIT"
if errorlevel  9 goto:EXIT
if errorlevel  8 goto:end_BACKMENU
if errorlevel  7 goto:SHUTDOWN_OPTIONS
if errorlevel  6 goto:BACKUP_CONFIG
if errorlevel  5 goto:SERVICES_DISABLE
if errorlevel  4 goto:TELEMETRY
if errorlevel  3 goto:MAS
if errorlevel  2 goto:DEFENDER_TOOLBOX
if errorlevel  1 goto:NETWORK_CONFIGURATION
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

::========================================================================================================================================

:NETWORK_CONFIGURATION
cls
color 0f
title  NETWORK CONFIGURATION
mode con cols=98 lines=32
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
Echo.
CmdMenuSel 0Ab1 "   [1] TEST CONNECTION" "   [2] PING WITH USER INPUT" "   [3] TRACE ROUTE WITH USER INPUT" "   [4] IP CONFIGURATION" "   [5] WIFI SETUP PREVIEW" "   [6] SETUP NETWORK SHARE" "   [7] REMOVE NETWORK MAP" "   [8] GO BACK"  "   [9] EXIT"
if errorlevel  9 goto:EXIT
if errorlevel  8 goto:end_COMPUTER_CONFIGURATION
if errorlevel  7 goto:REMOVE_NETWORK_MAP
if errorlevel  6 goto:SETUP_NETWORK_SHARE
if errorlevel  5 goto:WIFI_CONFIURATION
if errorlevel  4 goto:CHANGE_IP
if errorlevel  3 goto:TRACE_ROUTE
if errorlevel  2 goto:PING
if errorlevel  1 goto:TEST_CONNECTION
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

::========================================================================================================================================

:TEST_CONNECTION
color 0f
mode con cols=98 lines=60
cls
ECHO THIS SECTION WILL RUN A CLI BASED SPEED TEST TO DETECT INTERNET STABILITY
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/speedtest.exe -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
start /wait C:\AIO\speedtest.exe
pause & mode con cols=98 lines=30 & goto end_NETWORK_CONFIGURATION
cls

::========================================================================================================================================

:CHANGE_IP
color 0f
mode con cols=98 lines=32
cls
echo:
title IP CONFIGURATION
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
Echo.
CmdMenuSel 0Ab1 "   [1] LIST ADAPTERS" "   [2] WIFI AUTOMATIC CONFIGURATION" "   [3] ETHERNET AUTOMATIC CONFIGURATION" "   [4] WIFI MANUAL" "   [5] ETHERNET MANUAL" "   [6] GO BACK"
if errorlevel 6 goto:end_NETWORK_CONFIGURATION
if errorlevel 5 goto:ETHERNET_MANUAL
if errorlevel 4 goto:WIFI_MANUAL
if errorlevel 3 goto:AUTOMATIC_CONFIGURATION_ETHERNET
if errorlevel 2 goto:AUTOMATIC_CONFIGURATION_WIFI
if errorlevel 1 goto:LIST_ADAPTERS
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

::========================================================================================================================================

:LIST_ADAPTERS
title LIST OF NETWORK CONFIGURATION
echo This section will display a list of all network configurations registered on device.
Netsh interface ip show config
pause & cls goto end_NETWORK_CONFIGURATION

:AUTOMATIC_CONFIGURATION_WIFI
color 0f
mode con cols=98 lines=32
title WIFI AUTOMATIC CONFIGURATION
cls
echo:
netsh interface ipv4 set address name="Wi-Fi" source=dhcp
netsh interface ipv4 set dnsservers name"Wi-Fi" source=dhcp
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WiFi Set-Up successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
pause & cls & ping google.com & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:AUTOMATIC_CONFIGURATION_ETHERNET
color 0f
mode con cols=98 lines=32
title ETHERNET AUTOMATIC CONFIGURATION
cls
echo:
netsh interface ipv4 set address name="Ethernet" source=dhcp
netsh interface ipv4 set dnsservers name"Ethernet" source=dhcp
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Ethernet Set-Up successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
pause & cls & ping google.com & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:WIFI_MANUAL
color 0f
mode con cols=98 lines=32
title WIFI MANUAL CONFIGURATION
cls
echo:
echo TYPE IN THE NESSESARY CONFIG IN THE FOLLOWING ORDER:
echo:
netsh interface ipv4 set address name="Wi-Fi" static %WIFI-IP% %WIFI-SUBNET% %WIFI-GATEWAY%
Set /P %WIFI-IP%=Enter an IP address:
Set /P %WIFI-SUBNET%=Enter SUBNET MASK:
Set /P %WIFI-GATEWAY%=Enter GATEWAY:
netsh interface ipv4 set dns name="Wi-Fi" %WIFI-DNS% primary
Set /P %WIFI-DNS%=ENTER DNS:
pause & cls & ping google.com & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:ETHERNET_MANUAL
color 0f
mode con cols=98 lines=32
title ETHERNET MANUAL CONFIGURATION
cls
echo:
echo TYPE IN THE NESSESARY CONFIG IN THE FOLLOWING ORDER:
echo:
netsh interface ipv4 set address name="Ethernet" static %ETHER-IP% %ETHER-SUBNET% %ETHER-GATEWAY%
Set /P %ETHER-IP%=Enter an IP address:
Set /P %ETHER-SUBNET%=Enter SUBNET MASK:
Set /P %ETHER-GATEWAY%=Enter GATEWAY:
netsh interface ipv4 set dns name="Wi-Fi" %ETHER-DNS% primary
Set /P %ETHER-DNS%=ENTER DNS:
pause & cls & ping google.com & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:PING
color 0f
mode con cols=98 lines=32
cls
echo:
echo EXAMPLES
echo 8.8.8.8 for GOOGLE
echo 1.1.1.1 for CLOUDFLARE
echo:
Set /P pinghost=Enter an IP address or hostname to ping:
ping.exe %pinghost% -t
pause & cls & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:TRACE_ROUTE
color 0f
mode con cols=98 lines=32
cls
Set /P config=Enter an IP address or hostname to trace:
tracert.exe -d -h 64 %config%
pause & cls & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:SETUP_NETWORK_SHARE
color 0f
mode con cols=98 lines=32
cls
echo:
title NETWORK SHARE MAP
net use %driveletter%: \\%COMPUTER_NAME%\%SHARE_NAME% /user:%USERNAME% %PASSWORD% /PERSISTENT:%YES_NO%
Set /P %Driveletter%=Enter an Letter to use for map:
Set /P %COMPUTER_NAME%=Enter an IP address or hostname for map:
Set /P %SHARE_NAME%=Enter an folder share name for map:
Set /P %YES_NO%=TYPE IN ONLY YES OR NO TO MAKE PERMANENT:
Set /P %USERNAME%=Enter USER ACCOUNT SHARE NAME (LEAVE BLANK IF THERE IS NONE):
Set /P %PASSWORD%=Enter Enter USER ACCOUNT PASSWORD (LEAVE BLANK IF THERE IS NONE):
pause & ping %COMPUTER_NAME% & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:REMOVE_NETWORK_MAP
color 0f
mode con cols=98 lines=32
cls
echo:
title REMOVE NETWORK MAP
net use %REMOVELETTER%: /delete
Set /P %REMOVELETTER%=ENTER MAPPED DRIVE LETTER TO REMOVE:
pause & cls & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:WIFI_CONFIURATION
setlocal enabledelayedexpansion
color 0f
mode con cols=98 lines=32
cls
ECHO:
title WiFi name list
echo This section will display all registered WIFI networks on this device.
echo Use PageUp or PageDown to scroll if needed item does not display.
netsh wlan show profile
pause & goto WiFi_prompt
if error "There is no wireless interface on the system." goto WiFiNo

:WiFi_prompt
color 0f
mode con cols=98 lines=60
cls
echo.
echo To view the WiFi password note down the name and press Y to continue,
echo If not then press N to go back to previous menu.
echo.
set /p wifiprompt="Do you want to continue? (Y/N): "
if %wifiprompt%==Y goto WiFiYes
if %wifiprompt%==y goto WiFiYes
if %wifiprompt%==N goto WiFiNo
if %wifiprompt%==n goto WiFiNo
cls
echo.
echo Please answer me!...
echo.
set /p pause="Press any key to continue!... "
goto WiFiYes

:WiFiYes
echo.
for /f "tokens=2delims=:" %%a in ('netsh wlan show profile ^|findstr ":"') do (
    set "ssid=%%~a"
    call :getpwd "%%ssid:~1%%"
)
:getpwd
set "ssid=%*"
for /f "tokens=2delims=:" %%i in ('netsh wlan show profile name^="%ssid:"=%" key^=clear ^| findstr /C:"Key Content"') do echo ssid: %ssid% pass: %%i
pause
echo.
cls & goto end_NETWORK_CONFIGURATION

:WiFiNo
cls & goto end_NETWORK_CONFIGURATION

::========================================================================================================================================

:BACKUP_CONFIG
color 0f
mode con cols=98 lines=32
title  BACKUP OPTIONS
cls
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
CmdMenuSel 0Ab1 "   [1] BACKUP WIFI CONFIGURATION" "   [2] RESTORE WIFI CONFIGURATION" "   [3] NETWORK INTERFACES CONFIGURATION BACKUP" "   [4] NETWORK INTERFACES CONFIGURATION RESTORE" "   [5] BACKUP DRIVERS" "   [6] RESTORE DRIVERS" "   [7] USER DATA BACKUP" " [8]   GO BACK"
if errorlevel  8 goto:end_COMPUTER_CONFIGURATION
if errorlevel  7 goto:USER_DATA
if errorlevel  6 goto:RESTORE_DRIVERS
if errorlevel  5 goto:BACHUP_DRIVERS
if errorlevel  4 goto:RESTORE_IP
if errorlevel  3 goto:Backup_IP
if errorlevel  2 goto:RESTORE_WIFI
if errorlevel  1 goto:BACKUP_WIFI
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

::========================================================================================================================================

:BACKUP_WIFI
color 0f
Title WIFI BACKUP
mode con cols=98 lines=32
cls
echo
md C:\AIO_BACKUP\NETWORK\WIFI
cd C:\AIO_BACKUP\NETWORK\WIFI
echo This will backup the WiFi config to C:\AIO_BACKUP\NETWORK\WIFI
netsh wlan export profile key=clear folder=C:\AIO_BACKUP\NETWORK\WIFI
start .
pause & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:RESTORE_WIFI
color 0f
Title WIFI RESTORE
mode con cols=98 lines=32
cls
echo
cd C:\AIO_BACKUP\NETWORK\WIFI
dir
netsh wlan add profile filename="C:\AIO_BACKUP\NETWORK\WIFI\%WIFINAME%.xml" user=all
echo Enter complete file name excluding .xml
echo exapmle: WIFI-TSUNAMI
echo the .xml will be added automatically
Set /P %WIFINAME%=ENTER PEVIEWED WIFI NAME TO ADD WIFI BACK:
pause & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:Backup_IP
color 0f
Title NETWORK INTERFACES CONFIGURATION BACKUP
mode con cols=98 lines=32
cls
echo
md C:\AIO_BACKUP\NETWORK\Interfaces
cd C:\AIO_BACKUP\NETWORK\Interfaces
echo This section will backupp all the network interfaces confiuration to C:\AIO_BACKUP\NETWORK\Interfaces
netsh interface dump > C:\AIO_BACKUP\NETWORK\Interfaces\netcfg.txt
start .
pause & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:RESTORE_IP
color 0f
Title NETWORK INTERFACES CONFIGURATION RESTORE
mode con cols=98 lines=32
cls
echo
cd C:\AIO_BACKUP\NETWORK\Interfaces
dir
echo This section will restore all the network interfaces confiuration from C:\AIO_BACKUP\NETWORK\Interfaces
netsh exec C:\AIO_BACKUP\NETWORK\Interfaces\netcfg.txt
start .
pause & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:BACHUP_DRIVERS
color 0f
Title DRIVERS BACKUP
mode con cols=98 lines=32
cls
echo
md C:\AIO_BACKUP\DRIVERS_EXPORT
cd C:\AIO_BACKUP\DRIVERS_EXPORT
powershell.exe Dism /Online /Export-Driver /Destination:C:\AIO_BACKUP\DRIVERS_EXPORT
echo.The operation completed successfully.
pause & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:RESTORE_DRIVERS
color 0f
Title DRIVERS RESTORE
mode con cols=98 lines=32
cls
echo
cd C:\AIO_BACKUP\DRIVERS_EXPORT
dir
powershell.exe Dism /Online /Add-Driver /Driver:C:\AIO_BACKUP\DRIVERS_EXPORT
echo.The operation completed successfully.
pause & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:USER_DATA
color 0f
Title USER DATA BACKUP AND RESTORE
mode con cols=98 lines=32
cls
echo
echo This section is still a work in progress, STAY TUNED!
@echo off
Powershell -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 1
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/6.EXTRAS/User_profile_Backup_and_Restore.ps1 -d, --dir=C:\AIO\ --allow-overwrite="true" --disable-ipv6
Powershell -ExecutionPolicy Bypass -File "C:\AIO\User_profile_Backup_and_Restore.ps1"  -verb runas
echo.The operation completed successfully.
pause & goto end_COMPUTER_CONFIGURATION
::========================================================================================================================================

::========================================================================================================================================

:DEFENDER_TOOLBOX
color 0f
mode con cols=98 lines=32
title  WINDOWS DEFENDER TOOLBOX
cls
mode con cols=98 lines=32
cls
ECHO:
ECHO THIS SECTION WILL ADD CERTAIN FIREWALL EXCEPTIONS FOR WINDOWS
ECHO WINDOWS ACTIVATION TOOLKITS AS WELL AS GIVE MEENS TO DISABLE
ECHO WINDOWS DEFENDER TO ALLOW THE TOOLKITS TO PROPERLY FUNTION.
rem this section still needs work
timeout 5 >nul
PAUSE

@echo off
Powershell -ExecutionPolicy Bypass Set-MpPreference -DisableRealtimeMonitoring 1
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/disable-windows-defender.ps1 -d, --dir=C:\AIO\WINDOWS_DEFENDER\ --allow-overwrite="true" --disable-ipv6
Powershell -ExecutionPolicy Bypass -File "C:\AIO\WINDOWS_DEFENDER\disable-windows-defender.ps1"  -verb runas

@echo off
START Powershell -nologo -noninteractive -windowStyle hidden -noprofile -command ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147685180 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147735507 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147736914 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147743522 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147734094 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147743421 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147765679 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 251873 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 213927 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ThreatIDDefaultAction_Ids 2147722906 -ThreatIDDefaultAction_Actions Allow -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\KMSAutoS -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\System32\SppExtComObjHook.dll -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\System32\SppExtComObjPatcher.exe -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\AAct_Tools -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\AAct_Tools\AAct_x64.exe -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\AAct_Tools\AAct_files\KMSSS.exe -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\AAct_Tools\AAct_files -Force; ^
Add-MpPreference -ExclusionPath C:\Windows\KMS -Force; ^
Add-MpPreference -ExclusionPath C:\WINDOWS\Temp\_MAS -Force; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation -Force; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\BIN\cleanosppx64.exe -Force; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\BIN\cleanosppx86.exe -Force; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\Activate.cmd -Force; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\Info.txt -Force; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\Activate.cmd -Force;
@echo off
CLS
ECHO NOW THE DEFENDER DISABLE APPLICATION WILL LOAD CLOSE IF NOT NEEDED
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/Defender_Tools.exe -d, --dir=C:\AIO\WINDOWS_DEFENDER\ --allow-overwrite="true" --disable-ipv6
start /wait C:\AIO\WINDOWS_DEFENDER\Defender_Tools.exe
timeout 2 >nul
pause & cls & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:MAS
color 0f
mode con cols=98 lines=32
cls
ECHO THE FILE HERE WILL BE CHANGED INTO MULTIPLE PACKS AND TRIGGERS STAY TUNED
powershell.exe -Command "irm https://massgrave.dev/get | iex"
rem powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/MAS.cmd" -O "%USERPROFILE%\AppData\Local\Temp\AIO\MAS.cmd"
rem call %USERPROFILE%\AppData\Local\Temp\AIO\MAS.cmd
rem call C:\AIO\MAS.cmd
cls & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:TELEMETRY
color 0f
mode con cols=98 lines=32
cls
ECHO THE FILE HERE WILL BE CHANGED INTO MULTIPLE PACKS AND TRIGGERS STAY TUNED
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /F 1> NUL
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/block-telemetry.ps1 -d, --dir=C:\AIO\ --allow-overwrite="true" --disable-ipv6
Powershell -ExecutionPolicy Bypass -File "C:\AIO\block-telemetry.ps1"  -verb runas
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/ooshutup10.exe -d, --dir=C:\AIO\ --allow-overwrite="true" --disable-ipv6
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/ooshutup10.cfg -d, --dir=C:\AIO\ --allow-overwrite="true" --disable-ipv6
start /wait C:\AIO\ooshutup10.exe ooshutup10.cfg /quiet
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Telemetry blocked successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:SERVICES_DISABLE
color 0f
mode con cols=98 lines=32
Title SERVICES DISABLE
echo Currently working on the services list that mostly destroys windows overall performance.
echo Press any key to continue . . .
timeout 2 >nul

rem Query the SC service name. SC aka Service Control has different names for the services
rem and you cannot disable them using the actual service name listed on services.msc.
rem Instead we need to send a query to get the service name and then we can run a query to disable it
rem Get the name of the service you want to disable e.g.
rem    Apple Mobile Device
rem    AMD FUEL Service
rem    ASP.NET State Service
rem    ...
rem   Sc Getkeyname "Key Name For Service"
rem Example
rem   sc GetKeyName “AMD FUEL Service” (including the quotes!)

rem Sc does not account for typos.
rem If you do not enter the service name EXACTLY as seen on the services.msc
rem list, then it will give you the error “The specified service does not
rem exist as an installed service”, no matter what!

rem To configure the services you need to modify,
rem add the following to the string showed in the example below:
rem Example
rem    sc config “AMD Fuel Service” start= disabled

rem In the query above you can replace disabled with the following states:
rem    boot | system | auto | demand | disabled | delayed-auto

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('IF YOU WOULD LIKE TO CONTRIBUTE TO THE SERVICES PLEASE RERUN AIO AND GO TO 1.INFORMATION THEN ONTO 1.QUICK INFORMATION CONFIGURATION AND ACCEPT AGREEMENT FOR THE DIAGNOSTICS POPUP TO FURTHER INVESTIGATE EXTRA SERVICES FOR FUTURE USE. Do you agree?', 'EMAIL CONFIRMATION', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\AIO\sout.tmp
set /p SOUT=<%TEMP%\AIO\sout.tmp
if %SOUT%==Yes goto YES_ALLOWED
if %SOUT%==No goto NO_DISALLOWED
:YES_ALLOWED
goto SERVICES_ALLOWED
:NO_DISALLOWED
goto SERVICES_DISALLOWED

:SERVICES_ALLOWED
@echo off
echo DISABLING KNOWN WINDOWS SERVICES
timeout 2 >nul
sc config "bits" start= disabled
sc config "BDESVC" start= disabled
sc config "BcastDVRUserService_7c360" start= disabled
sc config "GoogleChromeElevationService" start= disabled
sc config "gupdate" start= disabled
sc config "gupdatem" start= disabled
sc config "vmickvpexchange" start= disabled
sc config "vmicguestinterface" start= disabled
sc config "vmicshutdown" start= disabled
sc config "vmicheartbeat" start= disabled
sc config "vmcompute" start= disabled
sc config "vmicvmsession" start= disabled
sc config "vmicrdv" start= disabled
sc config "vmictimesync" start= disabled
sc config "vmicvss" start= disabled
sc config "WdNisSvc" start= disabled
sc config "WinDefend" start= disabled
sc config "MicrosoftEdgeElevationServ" start= disabled
sc config "edgeupdate" start= disabled
sc config "edgeupdatem" start= disabled
sc config "MozillaMaintenance" start= disabled
sc config "SysMain" start= disabled
sc config "TeamViewer" start= disabled
sc config "Sense" start= disabled
sc config "MixedRealityOpenXRSvc" start= disabled
sc config "WSearch" start= manual
sc config "XboxGipSvc" start= disabled
sc config "XblAuthManager" start= disabled
sc config "XblGameSave" start= disabled
sc config "XboxNetApiSvc" start= Disabled
echo If any errors occured during disabling phase please rerun AIO as Administrator.
PAUSE & cls & goto end_COMPUTER_CONFIGURATION

:SERVICES_DISALLOWED
Echo
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('NO SERVICES WAS DISABLED BY PRESSING NO... Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls & goto end_COMPUTER_CONFIGURATION
::========================================================================================================================================
::========================================================================================================================================

REM UPDATE SECTION FOR WINDOWS, APPLICATIONS AND DRIVERS

::========================================================================================================================================
::========================================================================================================================================

:UPDATER
color 0f
mode con cols=98 lines=32
title  UPDATER
cls
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
CmdMenuSel 0Ab1 "   [1] WINDOWS UPDATE" "   [2] WINDOWS UPDATE PAUSER" "   [3] SOFTWARE UPDATER" "   [4] DRIVER_UPDATER" "   [5] GO BACK" "   [6] EXIT"
if errorlevel  6 goto:EXIT
if errorlevel  5 goto:end_BACKMENU
if errorlevel  4 goto:DRIVER_UPDATER
if errorlevel  3 goto:SOFTWARE_UPDATER
if errorlevel  2 goto:WINDOWS_UPDATE_PAUSER
if errorlevel  1 goto:WINDOWS_UPDATE
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

::========================================================================================================================================

:WINDOWS_UPDATE
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS UPDATER
echo This will start a Windows Manual Updater
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/WUpdater.exe -d, --dir=C:\AIO\WINDOWS_UPDATE\ --allow-overwrite="true" --disable-ipv6
start /wait C:\AIO\WINDOWS_UPDATE\WUpdater.exe
timeout 2 >nul
del %USERPROFILE%\AppData\Local\Temp\AIO\WUpdater.exe
pause & goto UPDATER

::========================================================================================================================================

:WINDOWS_UPDATE_PAUSER
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS UPDATE PAUSE
echo This section will give options to pause Windows Update...
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/UPDATES_PAUSE_TASK.ps1 -d, --dir=C:\AIO\WINDOWS_UPDATE\ --allow-overwrite="true" --disable-ipv6
Powershell -ExecutionPolicy Bypass -File "C:\AIO\WINDOWS_UPDATE\UPDATES_PAUSE_TASK.ps1"  -verb runas
timeout 2 >nul
pause & goto UPDATER


::========================================================================================================================================

:SOFTWARE_UPDATER
color 0f
mode con cols=98 lines=32
title  SOFTWARE UPDATER
echo The script will automatically download and install packages managers that will give an indication
echo of what you as a user would be able to use for the rest of the script. A few items will be changed
echo to make it much more visible to use with color based indicators.

:: Initialize variables
set chocoInstalled=0
set wgetInstalled=0
set wingetInstalled=0
set curlInstalled=0

echo Checking for package managers...

:: Check if Chocolatey is already installed
where choco >nul 2>&1
if %errorlevel% equ 0 (
    echo Chocolatey is already installed.
    set chocoInstalled=1
)

:: Install Chocolatey if not already installed
if %chocoInstalled% equ 0 (
    echo Installing Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

    :: Restart the script to continue with the rest of the installation process after Chocolatey is installed
    powershell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs" -Verb RunAs && exit
)

:: Check if wget is already installed
where wget >nul 2>&1
if %errorlevel% equ 0 (
    echo wget is already installed.
    set wgetInstalled=1
)

:: Install wget if not already installed
if %wgetInstalled% equ 0 (
    echo Installing wget...
    choco install -y wget
    if %errorlevel% neq 0 (
        echo Error installing wget. Please try again or install manually.
        goto end
    )
    set wgetInstalled=1
)

:: Check if curl is already installed
where curl >nul 2>&1
if %errorlevel% equ 0 (
    echo curl is already installed.
    set curlInstalled=1
)

:: Install curl if not already installed
if %curlInstalled% equ 0 (
    echo Installing curl...
    choco install -y curl
    if %errorlevel% neq 0 (
        echo Error installing curl. Please try again or install manually.
        goto end
    )
    set curlInstalled=1
)

:: Check if winget is already installed
where winget >nul 2>&1
if %errorlevel% equ 0 (
    echo winget is already installed.
    set wingetInstalled=1
)

:: Install winget if not already installed
if %wingetInstalled% equ 0 (
    echo Installing winget...
    powershell Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    powershell Install-Script -Name winget-install -Force
    powershell winget-install.ps1
    if %errorlevel% neq 0 (
        echo Error installing winget. Please try again or install manually.
        goto end
    )
    set wingetInstalled=1
)

:: Display installation status
cls
echo Chocolatey installed: %chocoInstalled%
echo wget installed: %wgetInstalled%
echo curl installed: %curlInstalled%
echo winget installed: %wingetInstalled%
echo
echo You can now choose wether to go back to previous menu or continue with selections
echo showcased below.
pause

cls
echo This section will give options to update the software
echo Pre_Selected or gives options to self select
Echo. Select the Menu-options (you can use KEYBOARD or MOUSE)
echo.
CmdMenuSel 0Ab1 "   [1] PatchMyPC Pre-Set Selections" "   [2] PatchMyPC Self Select" "   [3] Chocolatey Pre-Set Selections" "   [4] Chocolatey Self Select" "   [5] Winget-ui temp setup" "   [6] GO BACK" "   [6] EXIT"
if errorlevel  7 goto:EXIT
if errorlevel  6 goto:UPDATER
if errorlevel  5 goto:WINGET-UI
if errorlevel  4 goto:Chocolatey_GUI
if errorlevel  3 goto:Chocolatey
if errorlevel  2 goto:PatchMyPC_OWN_SELECTIONS
if errorlevel  1 goto:PatchMyPC
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

:PatchMyPC
cls
color 0f
mode con cols=98 lines=32
TITLE PatchMyPC auto setup
echo This will start a SOFTWARE UPDATE SESSION...
echo.
echo Patch My PC is an automated patch management application that simplifies the process of
echo keeping software up-to-date and secure. It scans your computer for installed software
echo and automatically installs available updates for a wide range of third-party applications,
echo including popular ones like Google Chrome, Mozilla Firefox, and Adobe Flash Player.
echo.
echo In addition, Patch My PC offers additional features such as the ability to uninstall software,
echo disable startup programs, and create a system restore points. It is user-friendly and requires
echo minimal configuration, making it a popular choice for both home users and IT professionals.
echo.
echo A bunch of software will be auto-installed based on our client's needs.
echo.
pause
REM Check if PatchMyPC is already installed
if exist "C:\AIO\SOFTWARE_UPDATER\patchmypc.exe" (
    echo PatchMyPC is already installed. Skipping installation...
    timeout 2 >nul
    pause & cls & goto UPDATER
)

REM Download PatchMyPC installer and configuration file
echo Downloading PatchMyPC installer and configuration file...
set "TMP_DIR=C:\AIO\SOFTWARE_UPDATER\"
if not exist "%TMP_DIR%" mkdir "%TMP_DIR%"
set "PATCHMYPCEXE=%TMP_DIR%PatchMyPC.exe"
set "PATCHMYPCCONFIG=%TMP_DIR%PatchMyPC.ini"
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/PRE-SELECT/PatchMyPC.exe -d, --dir="%TMP_DIR%" --allow-overwrite="true" --disable-ipv6
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/PRE-SELECT/PatchMyPC.ini -d, --dir="%TMP_DIR%" --allow-overwrite="true" --disable-ipv6

REM Install PatchMyPC
echo Installing PatchMyPC...
set "PATCHMYPCEXE_PATH=%TMP_DIR%PatchMyPC.exe"
set "PATCHMYPCCONFIG_PATH=%TMP_DIR%PatchMyPC.ini"
try {
    START /wait "%PATCHMYPCEXE_PATH%" /auto switch
} catch {
    echo Error installing PatchMyPC. %ERRORLEVEL%
    timeout 2 >nul
    pause & cls & goto UPDATER
}

echo PatchMyPC successfully installed.
timeout 2 >nul
pause & cls & goto UPDATER

:PatchMyPC_OWN_SELECTIONS
cls
color 0f
mode con cols=98 lines=32
TITLE PatchMyPC Self Selection setup

echo This will start a SOFTWARE UPDATE SESSION...
echo.
echo Patch My PC is an automated patch management application that simplifies the process of
echo keeping software up-to-date and secure. It scans your computer for installed software
echo and automatically installs available updates for a wide range of third-party applications,
echo including popular ones like Google Chrome, Mozilla Firefox, and Adobe Flash Player.
echo.
echo In addition, Patch My PC offers additional features such as the ability to uninstall software,
echo disable startup programs, and create a system restore points. It is user-friendly and requires
echo minimal configuration, making it a popular choice for both home users and IT professionals.
echo.
echo Feel free to install any software that you would need, by only selecting the checked boxes
echo for the software of your own choice and pressing the dedicated install button.
echo.
pause
REM Check if PatchMyPC is already installed
if exist "C:\AIO\SOFTWARE_UPDATER\patchmypc.exe" (
    echo PatchMyPC is already installed. Skipping installation...
    timeout 2 >nul
    pause & cls & goto UPDATER
)

REM Download PatchMyPC installer and configuration file
echo Downloading PatchMyPC installer and configuration file...
set "TMP_DIR=C:\AIO\SOFTWARE_UPDATER\"
if not exist "%TMP_DIR%" mkdir "%TMP_DIR%"
set "PATCHMYPCEXE=%TMP_DIR%PatchMyPC.exe"
set "PATCHMYPCCONFIG=%TMP_DIR%PatchMyPC.ini"
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/SELF-SELECT/PatchMyPC.exe -d, --dir="%TMP_DIR%" --allow-overwrite="true" --disable-ipv6
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/SELF-SELECT/PatchMyPC.ini -d, --dir="%TMP_DIR%" --allow-overwrite="true" --disable-ipv6

REM Install PatchMyPC
echo Installing PatchMyPC...
set "PATCHMYPCEXE_PATH=%TMP_DIR%PatchMyPC.exe"
set "PATCHMYPCCONFIG_PATH=%TMP_DIR%PatchMyPC.ini"
try {
    START /wait "%PATCHMYPCEXE_PATH%" /auto switch
} catch {
    echo Error installing PatchMyPC. %ERRORLEVEL%
    timeout 2 >nul
    pause & cls & goto UPDATER
}

echo PatchMyPC successfully installed.
timeout 2 >nul
pause & cls & goto UPDATER

:Chocolatey
cls
color 0f
mode con cols=98 lines=32
TITLE Chocolatey Installer Setup
echo This will start a Chocolatey INSTANCE SOFTWARE UPDATE SESSION...
echo A bunch of software will be auto-installed in accordance with clients we have worked with...

rem Check if Chocolatey is already installed
where choco >nul 2>nul
if %errorlevel% equ 0 (
    echo Chocolatey is already installed on the system.
    pause & goto UPDATER
)

rem Install Chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

rem Download and run Chocolatey preset
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/choco_Preset.ps1 -d, --dir=C:\AIO\ --allow-overwrite="true" --disable-ipv6
try {
    Powershell -ExecutionPolicy Bypass -File "C:\AIO\choco_Preset.ps1"  -verb runas
} catch {
    echo An error occurred while running the Chocolatey preset.
    pause & goto UPDATER
}

timeout 2 >nul
pause & cls & goto UPDATER

:Chocolatey_GUI
cls
color 0f
mode con cols=98 lines=32
TITLE Chocolatey Installer Setup
echo This will start a software update session using the Chocolatey package manager. Please wait while it downloads and installs update...

@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

if %errorlevel% neq 0 (
    echo An error occurred while installing the Chocolatey package manager.
    echo Please check your internet connection and try again later.
    timeout 5
    exit /b
)

rem Check if Chocolatey is already installed and reinstall it if necessary.
choco upgrade chocolatey --force

if %errorlevel% neq 0 (
    echo An error occurred while upgrading the Chocolatey package manager.
    echo Please check your internet connection and try again later.
    timeout 5
    exit /b
)

echo Chocolatey package manager has been successfully installed and upgraded.

echo Installing Chocolatey GUI...

choco install chocolateygui -y
if %errorlevel% neq 0 (
    echo An error occurred while installing Chocolatey GUI.
    echo Please check your internet connection and try again later.
    timeout 5
    exit /b
)

echo Chocolatey GUI has been successfully installed.
echo.
echo All software updates have been successfully installed.
echo Install other software packages as needed.
timeout 2 >nul
pause & cls & goto UPDATER

:WINGET-UI
echo this is a temporary setup for winget
winget install --id=SomePythonThings.WingetUIStore -e
timeout 2 >nul
pause & cls & goto UPDATER

::========================================================================================================================================

:DRIVER_UPDATER
cls
color 0f
mode con cols=98 lines=32
Title DRIVER UPDATER
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SNAPPY_DRIVER.zip -d, --dir=C:\AIO\SNAPPY_DRIVER\ --allow-overwrite="true" --disable-ipv6
cd /d %~dp0
Call :UnZipFile "C:\AIO\SNAPPY_DRIVER\" "C:\AIO\SNAPPY_DRIVER\SNAPPY_DRIVER.zip"
exit /b

:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%

if not exist "C:\AIO\SNAPPY_DRIVER\" mkdir "C:\AIO\SNAPPY_DRIVER\"
7z x -y -o"C:\AIO\SNAPPY_DRIVER\" "C:\AIO\SNAPPY_DRIVER\SNAPPY_DRIVER.zip"

if not exist "C:\AIO\SNAPPY_DRIVER\" mkdir "C:\AIO\SNAPPY_DRIVER\"
powershell Expand-Archive -Path "C:\AIO\SNAPPY_DRIVER\SNAPPY_DRIVER.zip" -DestinationPath "C:\AIO\SNAPPY_DRIVER\" -Force

wmic cpu get architecture | find "64" > nul
if %errorlevel% equ 0 goto AMD64
wmic cpu get addresswidth | find "64" > nul
if %errorlevel% equ 0 goto AMD64
goto x86

:UNSUPPORTED
echo Unsupported architecture "%processor_architecture%"!
echo  Not found 'Snappy Driver Installer'!
echo.
timeout 6
pause & cls & goto end_UPDATER

:AMD64
start /wait /b C:\AIO\SNAPPY_DRIVER\SDI_x64_R2111.exe -checkupdates -autoupdate -autoclose
echo SNAPPY DRIVER INSTALLER x64
pause & cls & goto end_UPDATER

:x86
start /wait /b C:\AIO\SNAPPY_DRIVER\SDI_R2111.exe -checkupdates -autoupdate -autoclose
echo SNAPPY DRIVER INSTALLER x86
pause & cls & goto end_UPDATER
:UNSUPPORTED
echo Unsupported architecture "%processor_architecture%"!
echo  Not found 'Snappy Driver Installer'!
echo.
timeout 6
pause & cls & goto end_UPDATER

::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================

:CLEANER
cls
color 0f
mode con cols=98 lines=40
TITLE PC Cleanup Utility
ECHO THIS OPTION WILL GIVE OPTIONS TO CLEAN UP TEMPORARY ITEMS FROM WINDOWS
echo ASWELL AS DEBLOAT A FEW OF WINDOWS PREINSTALLED APPLICATIONS
ECHO THERE ARE 2 OTHER REPAIR TOOLS AS A LAST RESORT REPAIR.
ECHO PLEASE READ BEFORE PROCEEDING
echo.
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
echo.
CmdMenuSel 0Ab1 "   [1] Disk Cleanup" "   [2] Disk Defragment" "   [3] DISK CHECK" "   [4] DISM AND SFC WINDOWS REPAIR" "   [5] Windows Debloater" "   [6] Group Policy Reset - USE AT OWN RISK" "   [7] WMI RESET - USE AT OWN RISK" "   [8] GO BACK" "   [9] EXIT"
if errorlevel 9 goto :EXIT
if errorlevel 8 goto :end_BACKMENU
if errorlevel 7 goto :WMI_RESET_AGREEMENT
if errorlevel 6 goto :GROUP_POLICY_RESET_AGREEMENT
if errorlevel 5 goto :Windows_Debloater
if errorlevel 4 goto :DISM_and_SFC
if errorlevel 3 goto :DISK_CHECK
if errorlevel 2 goto :Disk_Defragment
if errorlevel 1 goto :Disk_Cleanup
goto error
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul
cls

:Disk_Cleanup
cls
echo.
title DISK CLEANUP
echo.
echo Cleaning temporary files...

REM delete temporary files
del /s /q %temp%\*
del /s /q %windir%\temp\*
del /s /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
del /s /q "%userprofile%\AppData\Local\Temp\*.*"
del /s /q "%windir%\Prefetch\*.*"
del /f /q "%userprofile%\Cookies\*.*"
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
del /f /q "%userprofile%\AppData\Local\Temp\*.*"
del /s /f /q "c:\windows\temp\*.*"
rd /s /q "c:\windows\temp"
md "c:\windows\temp"
del /s /f /q "C:\WINDOWS\Prefetch"
del /s /f /q "%temp%\*.*"
rd /s /q "%temp%"
md %temp%
del /f /s /q "%systemdrive%\*.tmp"
del /f /s /q "%systemdrive%\*._mp"
del /f /s /q "%systemdrive%\*.log"
del /f /s /q "%systemdrive%\*.gid"
del /f /s /q "%systemdrive%\*.chk"
del /f /s /q "%systemdrive%\*.old"
del /f /s /q "%systemdrive%\recycled\*.*"
del /f /s /q "%windir%\*.bak"
del /f /s /q "%windir%\prefetch\*.*"
rd /s /q "%windir%\temp & md %windir%\temp"
del /f /q "%userprofile%\cookies\*.*"
del /f /q "%userprofile%\recent\*.*"
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
if exist "C:\WINDOWS\temp"del /f /q "C:WINDOWS\temp\*.*"
if exist "C:\WINDOWS\tmp" del /f /q "C:\WINDOWS\tmp\*.*"
if exist "C:\tmp" del /f /q "C:\tmp\*.*"
if exist "C:\temp" del /f /q "C:\temp\*.*"
if exist "%temp%" del /f /q "%temp%\*.*"
if exist "%tmp%" del /f /q "%tmp%\*.*"
DEL /S /Q "%TMP%\*.*"
DEL /S /Q "%TEMP%\*.*"
DEL /S /Q "%WINDIR%\Temp\*.*"
DEL /S /Q "%USERPROFILE%\Local Settings\Temp\*.*"
DEL /S /Q "%USERPROFILE%\Appdata\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache"
DEL /S /Q "%LocalAppData%\Temp"
DEL /S /Q "C:\Program Files (x86)\Google\Temp"
DEL /S /Q "C:\Program Files (x86)\Steam\steamapps\temp"
DEL /S /Q "U:\Games\steamapps\temp"
DEL /S /Q "C:\ProgramData\Microsoft\Windows\WER\Temp"
DEL /S /Q "C:\Users\All Users\Microsoft\Windows\WER\Temp"
DEL /S /Q "C:\Windows\Temp"
DEL /S /Q "C:\Windows\System32\DriverStore\Temp"
DEL /S /Q "C:\Windows\WinSxS\Temp"

REM remove cookies, recent files, and thumbnail cache
powershell -command "Remove-Item -Path '$env:userprofile\Cookies\*' -Force"
powershell -command "Remove-Item -Path '$env:userprofile\AppData\Local\Microsoft\Windows\Temporary Internet Files\*' -Force"
powershell -command "Remove-Item -Path '$env:userprofile\AppData\Local\Temp\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\temp\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\Prefetch\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:temp\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:userprofile\Recent\*' -Force"
powershell -command "Remove-Item -Path '$env:userprofile\Local Settings\Temporary Internet Files\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:userprofile\Local Settings\Temp\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:userprofile\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\*.tmp' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\*._mp' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\*.log' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\*.gid' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\*.chk' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\*.old' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:systemdrive\Recycled\*.*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\*.bak' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\Prefetch\*.*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\SoftwareDistribution\Download\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\ServiceProfiles\LocalService\AppData\Local\Microsoft\Windows\Temporary Internet Files\*' -Recurse -Force"
powershell -command "Remove-Item -Path '$env:windir\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\Temporary Internet Files\*' -Recurse -Force"
powershell -command "Remove-Item -Path $env:TEMP\* -Recurse -Force"
powershell -command "Remove-Item -Path $env:windir\Temp\* -Recurse -Force"

echo Temporary files have been cleaned.

REM launch disk cleaner for verification cleanup
cleanmgr /d C:
cleanmgr /sageset:1
cleanmgr /sagerun:1
cleanmgr /VERYLOWDISK /sagerun:0
ipconfig /flushdns
echo.
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Disk Cleanup successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
echo.
cls & goto end_CLEANER

:Disk_Defragment
cls
color 0f
mode con cols=98 lines=32
cls
echo --------------------------------------------------------------------------------
echo Disk Defragment
echo --------------------------------------------------------------------------------
echo.
echo Defragmenting hard disks...
ping localhost -n 3 >nul
defrag -c -v
cls
echo --------------------------------------------------------------------------------
echo Disk Defragment
echo --------------------------------------------------------------------------------
echo.
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Disk defrag completed successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
echo.
pause & goto end_CLEANER

:DISK_CHECK
color 0f
mode con cols=98 lines=32
TITLE DISK CHECK
cls
setlocal EnableDelayedExpansion
cls
echo ==================
ver | findstr /i "6\.[01]" > nul && set powershell_ver=6 || set powershell_ver=5
echo Installed PowerShell Version: %powershell_ver%

echo Detecting available disks...
echo list disk | diskpart > available_disks.txt
findstr /i /c:"Disk ###" /c:"Gpt" /c:"Status" available_disks.txt > disk_info.txt
type disk_info.txt
echo list volume | diskpart > available_volumes.txt
findstr /i /c:"Volume ###" /c:"Ltr" /c:"Label" /c:"Size" /c:"Fs" available_volumes.txt > volume_info.txt
type volume_info.txt

setlocal EnableDelayedExpansion
set /p disk=Enter number of disks:
set "disks="
for /l %%i in (1,1,%disk%) do (
  set /p drive=Enter drive letter of disk %%i:
  set "disks=!disks! /d %%i: !drive!"
)
echo Disk letter and numbers selected:
echo %disks%
echo ========================
echo Disk Check Menu
echo ========================
Echo.Select the Menu-options (you can use KEYBOARD or MOUSE)
echo.
CmdMenuSel 0Ab1 "   [1] CHKDSK (cmd)        : Compatible with all Windows versions" "   [2] Repair-Volume (PSv4): Compatible with Windows 8.1/Server 2012 R2 or newer" "   [3] Test-Volume (PSv4)  : Compatible with Windows 8.1/Server 2012 R2 or newer" "   [4] Repair-Partition (PSv4): Compatible with Windows 8.1/Server 2012 R2 or newer" "   [5] Disk Space Test (cmd): Compatible with all Windows versions" "   [6] Get Volume Info (cmd): Compatible with all Windows versions" "   [7] Read Speed Test (cmd): Compatible with all Windows versions" "   [8] Write Speed Test (cmd): Compatible with all Windows versions" "   [9] Go Back"
set /p choice=Enter your choice:
if '%choice%'=='1' goto CHKDSK
if '%choice%'=='2' goto POWERSHELL_REPAIR_VOLUME
if '%choice%'=='3' goto TEST_VOLUME
if '%choice%'=='4' goto REPAIR_PARTITION
if '%choice%'=='5' goto DISK_SPACE_TEST
if '%choice%'=='6' goto VOLUME_INFO
if '%choice%'=='7' goto READ_SPEED_TEST
if '%choice%'=='8' goto WRITE_SPEED_TEST
if '%choice%'=='9' goto end_CLEANER
goto DISK_CHECK
goto error
cls
Echo. You Selected: Option %Errorlevel%
Echo.
Echo.
timeout /t 2 >nul

:CHKDSK
set /p drive_letter=Enter drive letter that needs attention:
CHKDSK %drive_letter%: /R /I /F /X
pause
goto DISK_CHECK

:POWERSHELL_REPAIR_VOLUME
powershell.exe -Command "Repair-Volume -DriveLetter %drive_letter% -SpotFix"
pause
goto DISK_CHECK

:TEST_VOLUME
powershell.exe -Command "Get-Volume -DriveLetter %drive_letter% | Test-Volume"
pause
goto DISK_CHECK

:REPAIR_PARTITION
powershell.exe -Command "Repair-Volume -DriveLetter %drive_letter% -OfflineScanAndFix"
pause
goto DISK_CHECK

:DISK_SPACE_TEST
set /p drive_letter=Enter drive letter to test disk space:
powershell.exe -Command "Get-PSDrive %drive_letter% | Select-Object Used, Free, Provider, Root"
pause
goto DISK_CHECK

:VOLUME_INFO
set /p drive_letter=Enter drive letter to get volume info:
powershell.exe -Command "Get-Volume -DriveLetter %drive_letter% | Select-Object DriveLetter, FileSystemLabel, HealthStatus"
pause
goto DISK_CHECK

:READ_SPEED_TEST
for /f "tokens=2 delims=:" %%a in ('wmic diskdrive get index^,model /format:list ^| find "="') do set "model=%%a"
echo Testing read speed of drive %drive_letter% using model %model%...
winsat disk -read -drive %drive_letter%
pause
goto DISK_CHECK

:WRITE_SPEED_TEST
for /f "tokens=2 delims=:" %%a in ('wmic diskdrive get index^,model /format:list ^| find "="') do set "model=%%a"
echo Testing write speed of drive %drive_letter% using model %model%...
winsat disk -write -drive %drive_letter%
pause
goto DISK_CHECK

:DISM_and_SFC
color 0f
mode con cols=98 lines=32
TITLE DISM and SFC
cls
echo ------------------------------------------------
echo Windows component files check - procedure 1 of 3
echo ------------------------------------------------
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo --------------------------------------------------
echo Phase 1 of 2 completed
echo --------------------------------------------------
Dism.exe /online /Cleanup-Image /SPSuperseded
echo --------------------------------------------------
echo Phase 2 of 2 completed
echo PRESS ANY KEY TO CONTINUE.
pause >null
del null
cls
echo --------------------------------------------------------------
echo Checking the integrity of the Windows image - procedure 2 of 3
echo --------------------------------------------------------------
DISM /Online /Cleanup-Image /CheckHealth >nul 2>&1
if %errorlevel% neq 0 (
    echo --------------------------------------------------
    echo Errors detected in DISM tool. Cannot proceed with SFC.
    echo --------------------------------------------------
) else (
    echo --------------------------------------------------
    echo Phase 1 of 3 completed
    echo --------------------------------------------------
    DISM /Online /Cleanup-Image /ScanHealth
    echo --------------------------------------------------
    echo Phase 2 of 3 completed
    echo --------------------------------------------------
    DISM /Online /Cleanup-Image /RestoreHealth
    echo --------------------------------------------------
    echo Phase 3 of 3 completed
    echo PRESS ANY KEY TO CONTINUE.
    pause >null
    del null
    cls
    echo -------------------------------------------------
    echo Running System file check - procedure 3 of 3
    echo -------------------------------------------------
    sfc /scannow >sfc.log
    echo --------------------------------------------------------------------------------
    echo If SFC found some errors and could not repair, re-run the script after a reboot.
    echo --------------------------------------------------------------------------------
    findstr /C:"[SR]" sfc.log >sfcerrors.log
    if not exist sfcerrors.log (
        echo No errors found in SFC.
    ) else (
        echo SFC detected errors. Attempting repair...
        set /p media="Enter the drive letter of the Windows installation media that contains the install.wim file (e.g., D): "
        for /f "tokens=1,2* delims=]" %%a in ('type sfcerrors.log ^| find /i "[SR]"') do (
            set "file=%%~b"
            set "file=!file:~1!"
            echo Repairing file !file!...
            DISM /Online /Cleanup-Image /RestoreHealth /source:WIM:%media%:\sources\install.wim:1 /limitaccess /replace:"!file!"
        )
        echo Repair complete. Re-running SFC...
        sfc /scannow
        echo --------------------------------------------------------------------------------
        echo If SFC found some errors and could not repair, re-run the script after a reboot.
        echo --------------------------------------------------------------------------------
    )
    pause & cls & goto end_CLEANER
)
pause & cls & goto end_CLEANER

:Windows_Debloater
color 0f
mode con cols=98 lines=32
TITLE DEBLOATER
ECHO THIS OPTION WILL DEBLOAT WINDOWS 10 + 11
timeout 2 >nul
aria2c https://github.com/coff33ninja/AIO/blob/92e827cb6a57ef688d1f87f0635aa91a337e7a68/TOOLS/4.CLEANER_REPAIR/DEBLOATER.ps1 -d, --dir=%USERPROFILE%\AppData\Local\Temp\AIO\ --allow-overwrite="true" --disable-ipv6
Powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\AppData\Local\Temp\AIO\Debloater.ps1"  -verb runas
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('This device has been successfully debloated. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls & goto end_CLEANER

:GROUP_POLICY_RESET_AGREEMENT
cls
color 0f
mode con cols=98 lines=32
TITLE GROUP POLICY RESET
echo GROUP POLICY AGREEMENT
timeout 2 >nul
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('The Group Policy Editor is an important tool for Windows OS using which System Administrators can fine-tune system settings. It has several infrastructural configuration options that allow you to make adjustments to the specific performance and security settings for users and computers. Sometimes you might end up tweaking your Group Policy Editor a bit further down the line here your computer starts behaving in an unwanted way. This is when you know that its time to reset all Group Policy settings to default and save yourself the pain of reinstalling Windows again. This section is Pre-Setup so that you wont have to look through forums to find a solution. Please reboot once the cleanup is complete. Press YES if you understand. Press NO to go back to the previous section.', 'GROUP POLICY RESET AGREEMENT', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
if %OUT%==Yes cls & GOTO GROUP_POLICY_RESET
if %OUT%==No cls & goto CLEANER

:GROUP_POLICY_RESET
cls
color 0f
mode con cols=98 lines=32
title Group Policy Reset
ECHO The Group Policy Editor is an important tool for Windows OS, which allows
ECHO system administrators to fine-tune system settings. It has several
ECHO infrastructural configuration options that allow you to make adjustments
ECHO to specific performance and security settings for users and computers.
ECHO.
ECHO Sometimes, you might end up tweaking your Group Policy Editor to a point
ECHO where your computer starts behaving in an unwanted way. This is when you
ECHO know that it's time to reset all Group Policy settings to default and
ECHO save yourself the pain of reinstalling Windows. This section is pre-setup
ECHO so that you won't have to look through forums to find a solution.
ECHO.
ECHO Please reboot once the cleanup is complete...
ECHO.


RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
RD /S /Q "%WinDir%\System32\GroupPolicy"
gpupdate /force
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /f
reg delete "HKCU\Software\Microsoft\WindowsSelfHost" /f
reg delete "HKCU\Software\Policies" /f
reg delete "HKLM\Software\Microsoft\Policies" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies" /f
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f
reg delete "HKLM\Software\Microsoft\WindowsSelfHost" /f
reg delete "HKLM\Software\Policies" /f
reg delete "HKLM\Software\WOW6432Node\Microsoft\Policies" /f
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies" /f
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; if([System.Windows.Forms.MessageBox]::Show('Group Policy has been successfully reset. Do you want to reboot?', 'COMPLETE', [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Information) -eq 'Yes'){Restart-Computer -Force}}"
goto :CLEANER

:WMI_RESET_AGREEMENT
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS MANAGEMENT INSTRUMENTATION RESET
echo WINDOWS MANAGEMENT INSTRUMENTATION RESET AGREEMENT
timeout 2 >nul
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Full WMI reset to the state when the operating system was installed is a serious measurement that should be well thought about, if needed at all. After the reset, you will need to reinstall any software that uses WMI repository. If, for example, your Server is System Center Configuration Manager Distribution Point or Pull Distribution Point, then you should not have any problem resetting though you will need to reinstall SCCM Client. However, keep in mind that if there are other uses for the server, you might need to check it afterwards. If youre in a case, when you need to reset WMI and it fixed your system to the state when you can boot backup your content and better reinstall. It should not be an escape solution. Press YES if you understand. Press NO to go back to the previous section.', 'WINDOWS MANAGEMENT INSTRUMENTATION RESET AGREEMENT', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
if %OUT%==Yes cls & GOTO WMI_RESET
if %OUT%==No cls & goto CLEANER

:WMI_RESET
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS MANAGEMENT INSTRUMENTATION RESET
echo Full WMI reset to the state when the operating system was installed
echo is a serious measurement that should be well thought about, if needed
echo at all. After the reset, you will need to reinstall any software that
echo uses WMI repository. If, for example, your Server is System Center
echo Configuration Manager Distribution Point or Pull Distribution Point,
echo then you should not have any problem resetting though you will need
echo to reinstall SCCM Client. However, keep in mind that if there are
echo other uses for the server, you might need to check it afterwards.
echo If you're in a case when you need to reset WMI and it fixed your
echo system to the state when you can boot backup your content and better
echo reinstall. It should not be an escape solution.
PAUSE

call :stage1
call :stage2
call :stage3

echo Windows Management interface has been successfully reset.
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Windows Management interface has been successfully reset. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
exit /b

:stage1
echo Salvaging WMI repository...
winmgmt /salvagerepository || call :salvage_failed
echo WMI repository salvaged successfully.
exit /b

:salvage_failed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository salvaging failed. Review the error message and try again.', 'WMI Repository Salvaging', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"
exit /b

:stage2
echo Resetting WMI repository...
winmgmt /resetrepository || call :reset_failed
echo WMI repository reset successfully.
exit /b

:reset_failed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository reset failed. Review the error message and try again.', 'WMI Repository Reset', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"
exit /b

:stage3
echo Rebuilding WMI repository...
call :disable_winmgmt_service
call :unregister_dlls
call :delete_repository_folder
call :register_dlls
call :rebuild_mofs
call :rebuild_mfls
call :rebuild_services
call :enable_winmgmt_service
echo WMI repository rebuilt successfully.
exit /b

:disable_winmgmt_service
echo Turning winmgmt service Startup type to Disabled...
sc config winmgmt start=disabled
echo Stopping winmgmt service...
net stop winmgmt /y
exit /b

:unregister_dlls
echo Registering / Reregistering Service DLLs...
regsvr32 /s %systemroot%\system32\scecli.dll
regsvr32 /s %systemroot%\system32\userenv.dll
exit /b

:delete_repository_folder
echo Entering WBEM folder...
cd /d %systemroot%\system32\wbem
echo Removing "repository" folder...
rd /S /Q repository
exit /b

:register_dlls
echo Registering / Reregistering Service DLLs...
for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s
for /f %%s in ('dir /b /s *.exe') do regsvr32 /s %%s
exit /b

:rebuild_mofs
echo Rebuilding MOFs...
for /f %%s in ('dir /b *.mof') do mofcomp %%s
exit /b

:rebuild_mfls
echo Rebuilding MFLs...
for /f %%s in ('dir /b *.mfl') do mofcomp %%s
exit /b

:rebuild_services
echo Registering / Reregistering wmiprvse Service...
wmiprvse /regserver
echo Registering / Reregistering winmgmt Service...
winmgmt /regserver
echo Entering WBEM folder in SysWOW64...

REM Enter WBEM folder in SysWOW64
cd /d %systemroot%\SysWOW64\wbem\
REM Remove “repository” folder
rd /S /Q repository
REM Register / Reregister Service DLLs
for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s
for /f %%s in ('dir /b /s *.exe') do regsvr32 /s %%s
for /f %%s in ('dir /b *.mof') do mofcomp %%s
for /f %%s in ('dir /b *.mfl') do mofcomp %%s

echo WMI repository reset completed.

REM Turn winmgmt service Startup type to Automatic
sc config winmgmt start = auto
REM Start winmgmt service
net start winmgmt

REM Notify the user that the WMI repository has been reset
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Windows Management Interface has been successfully reset. Press OK to continue.', 'WMI Repository Reset', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"

GOTO :CLEANER

:reset_failed
REM Notify the user that the WMI repository reset failed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository reset failed. Review the error message and try again.', 'WMI Repository Reset', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"

GOTO :CLEANER

:salvage_failed
REM Notify the user that the WMI repository salvaging failed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository salvaging failed. Review the error message and try again.', 'WMI Repository Salvaging', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"

GOTO :CLEANER

REM Prompt the user to select a category
CHOICE /C 123 /N /M "Select a category: 1) Reset WMI repository 2) Salvage WMI repository 3) Full WMI repository reset"

REM Call the appropriate function based on the user's choice
IF ERRORLEVEL 3 CALL :full_reset
IF ERRORLEVEL 2 CALL :salvage
IF ERRORLEVEL 1 CALL :reset

GOTO :CLEANER

:reset
REM Call the reset function
CALL :reset_func
GOTO :CLEANER

:salvage
REM Call the salvage function
CALL :salvage_func
GOTO :CLEANER

:full_reset
REM Call the full reset function
CALL :full_reset_func
GOTO :CLEANER

:reset_func
REM Perform the WMI repository reset
echo Performing WMI repository reset...
winmgmt /resetrepository

REM Test if the reset was successful
IF %ERRORLEVEL% EQU 0 (
    echo WMI repository reset completed successfully.
    REM Notify the user that the WMI repository has been reset
    powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Windows Management Interface has been successfully reset. Press OK to continue.', 'WMI Repository Reset', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
) ELSE (
REM Notify the user that the WMI repository salvaging failed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository salvaging failed. Review the error message and try again.', 'WMI Repository Salvaging', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"

REM Check if the WMI repository reset was successful
if %errorlevel% equ 0 (
REM Notify the user that the WMI repository reset was successful
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository reset completed successfully.', 'WMI Repository Reset', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
) else (
REM Notify the user that the WMI repository reset failed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('WMI repository reset failed. Review the error message and try again.', 'WMI Repository Reset', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"
)

REM Re-enable the winmgmt service
sc config winmgmt start=auto

REM Start the winmgmt service
net start winmgmt

REM Check if the winmgmt service started successfully
if %errorlevel% equ 0 (
REM Notify the user that the winmgmt service has started
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('The Windows Management Instrumentation service has been started successfully.', 'Winmgmt Service', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
) else (
REM Notify the user that the winmgmt service failed to start
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Failed to start the Windows Management Instrumentation service. Review the error message and try again.', 'Winmgmt Service', 'OK', [System.Windows.Forms.MessageBoxIcon]::Error);}"
)

REM Notify the user that the WMI repository has been successfully reset
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Windows Management interface has been successfully reset. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"

REM Clear the screen
cls && goto CLEANER
::========================================================================================================================================
::========================================================================================================================================

:WIN_INSTALL
cls
color 0f
mode con cols=98 lines=32
Title Windows Setup Test

REM Disable the first-run check for Internet Explorer
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v DisableFirstRunCustomize /t REG_DWORD /d 1 /f

REM Download the AIO.cmd file using different download tools with failover approach
set "downloaded=false"
set "url=https://raw.githubusercontent.com/coff33ninja/AIO/testing-irm-new-layout/files/WinNTSetup_462.zip"

REM Download using curl
curl %url% -o "C:\temp\WinNTSetup_462.zip" --silent
if exist "C:\temp\WinNTSetup_462.zip" set "downloaded=true" & goto :DownloadComplete
if %errorlevel% neq 0 (
    echo Failed to download using curl. Error: %errorlevel%
)

REM Download using wget
wget -O "C:\temp\WinNTSetup_462.zip" %url%
if exist "C:\temp\WinNTSetup_462.zip" set "downloaded=true" & goto :DownloadComplete
if %errorlevel% neq 0 (
    echo Failed to download using wget. Error: %errorlevel%
)

REM Download using aria2c
aria2c %url% -d "C:\temp" --allow-overwrite=true --disable-ipv6
if exist "C:\temp\WinNTSetup_462.zip" set "downloaded=true" & goto :DownloadComplete
if %errorlevel% neq 0 (
    echo Failed to download using aria2c. Error: %errorlevel%
)

REM Download using PowerShell Invoke-RestMethod
powershell -Command "Invoke-RestMethod -Uri '%url%' -OutFile 'C:\temp\WinNTSetup_462.zip' -UseBasicParsing"
if exist "C:\temp\WinNTSetup_462.zip" set "downloaded=true" & goto :DownloadComplete
if %errorlevel% neq 0 (
    echo Failed to download using Invoke-RestMethod. Error: %errorlevel%
)

REM Download using PowerShell Invoke-WebRequest
powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile 'C:\temp\WinNTSetup_462.zip' -UseBasicParsing"
if exist "C:\temp\WinNTSetup_462.zip" set "downloaded=true" & goto :DownloadComplete
if %errorlevel% neq 0 (
    echo Failed to download using Invoke-WebRequest. Error: %errorlevel%
)

:DownloadComplete
if %downloaded%==true (
    echo AIO.cmd file downloaded successfully.
) else (
    echo Failed to download WinNTSetup_462.zip file from all sources.
)

set "zipFile=C:\temp\WinNTSetup_462.zip"
set "destination=C:\temp\WinNTSetup_462"

REM Create the destination directory if it doesn't exist
if not exist "%destination%" mkdir "%destination%"

REM Unzip the file using expand.exe
expand.exe -F:* "%zipFile%" "%destination%\"

REM Check if the unzip operation was successful
if %errorlevel% equ 0 (
    echo File unzipped successfully.
) else (
    echo Failed to unzip the file. Error: %errorlevel%
)

PAUSE GOTO end_BACKMENU

::========================================================================================================================================
::========================================================================================================================================

:EXTRAS
cls
color 0f
mode con cols=98 lines=32
Title EXTRA ITEMS
ECHO STILL BLANK
PAUSE GOTO end_BACKMENU

::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================

::========================================================================================================================================

REM THIS SECTION RESERVED FOR PROGRESS BAR ANIMATION

::========================================================================================================================================

:end_WIN_INSTALL
cls & goto end_BACKMENU

::========================================================================================================================================
::========================================================================================================================================

:end_CLEANER
cls & goto CLEANER

::========================================================================================================================================
::========================================================================================================================================

:end_UPDATER
cls & goto UPDATER

::========================================================================================================================================
::========================================================================================================================================

:end_BACKMENU
cls & goto MainMenu

::========================================================================================================================================
::========================================================================================================================================

:end_NETWORK_CONFIGURATION
cls & goto NETWORK_CONFIGURATION

::========================================================================================================================================
::========================================================================================================================================

:end_COMPUTER_CONFIGURATION
cls & goto COMPUTER_CONFIGURATION

::========================================================================================================================================
::========================================================================================================================================

:EXIT
cls & exit
::========================================================================================================================================
::========================================================================================================================================



::========================================================================================================================================
::========================================================================================================================================
REM THIS SECTION RESERVED FOR A FEW INTRESTING ITEMS
::========================================================================================================================================
:EASTER
cls
echo you have been lied tool
pause & cls & goto end_BACKMENU
::========================================================================================================================================



::========================================================================================================================================
::========================================================================================================================================
REM THIS SECTION DOES NOT NEED ANY EDITING
::========================================================================================================================================
::========================================================================================================================================

:SHUTDOWN_OPTIONS
title Shutdown Script
mode con cols=98 lines=32
set seconds=1

cls
echo ===============================================================================
echo                               Shutdown Script
echo ===============================================================================
echo.
echo    Select an option:
echo.
echo    [1] Restart (default settings)
echo    [2] Restart and re-register applications
echo    [3] Restart to UEFI/BIOS menu
echo    [4] Restart and load advanced boot options menu
echo    [5] Shutdown (default settings)
echo    [6] Shutdown and re-register applications
echo    [7] Sign out user
echo    [8] Exit script
echo.
choice /c 12345678 /n /m "Enter your choice: "

if errorlevel 8 goto :end_BACKMENU
if errorlevel 7 call :signout
if errorlevel 6 call :shutdown /sg
if errorlevel 5 call :shutdown /s
if errorlevel 4 call :restart /r /o
if errorlevel 3 call :restart /r /fw
if errorlevel 2 call :restart /g
if errorlevel 1 call :restart /r
goto :menu

:signout
cls
echo.
echo Signing out...
echo.
choice /c YN /m "Are you sure you want to continue?"
if errorlevel 2 goto :menu
shutdown /l
goto :eof

:shutdown
cls
echo.
echo Shutting down...
echo.
choice /c YN /m "Are you sure you want to continue?"
if errorlevel 2 goto :menu
shutdown %1 /t %seconds%
goto :eof

:restart
cls
echo.
echo Restarting...
echo.
choice /c YN /m "Are you sure you want to continue?"
if errorlevel 2 goto :menu
shutdown %1 /t %seconds%
goto :eof

:end
echo Exiting script...
endlocal
exit /b
