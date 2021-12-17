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

:TERMS_AND_CONDITIONS_AGREEMENT
if exist c:/aio/tos.txt goto MainMenu
if errorlevel goto TERMS_AND_CONDITIONS
cls

::========================================================================================================================================
::========================================================================================================================================

:TERMS_AND_CONDITIONS
TITLE TERMS AND CONDITIONS
mode con cols=98 lines=32
cls
echo:
echo      ####################################################
echo      #  Read, Agree and Accept - Terms as Stated (TaS)  #
echo      ####################################################
echo:
echo           AIO version - 1.4
echo           Copyright (C) 2021  Coff33ninja - Darius-vr
echo:
echo               This program is distributed in order to simplify Windows Configuration,
echo               but WITHOUT ANY GUARANTEE; including, but not limited to, 
echo               the implied guarantee of RESALES or ANY OTHER unlisted purposes.
echo               See the GNU General Public License for more details.
echo               https://www.gnu.org/licenses/gpl-3.0.en.html
echo:
echo      The End-User Understands:
echo           [X] This product is licensed under GNU General Public v3.
echo           [X] Please note that this is an "AS IS" application.
echo           [X] As a GRAND RULE OF THUMB it is always great to read the script code first.
echo           [X] This code is compiled using fragments of other open source projects, including, 
echo               but not limited to github projects by Builtbybel, Massgravel and Slapanav
echo           [X] 
echo           [X] 
echo.
set /p op=      Do you agree to the terms and conditions as stated above? (Yes or No):
if %op%==Y goto MainMenu >> %USERPROFILE%\AppData\Local\Temp\AIO\ACCEPTEDTOS.txt
if %op%==Yes goto MainMenu >> %USERPROFILE%\AppData\Local\Temp\AIO\ACCEPTEDTOS.txt
if %op%==yes goto MainMenu >> %USERPROFILE%\AppData\Local\Temp\AIO\ACCEPTEDTOS.txt
if %op%==y goto MainMenu >> %USERPROFILE%\AppData\Local\Temp\AIO\ACCEPTEDTOS.txt
if %op%==N goto exit
if %op%==No goto exit
if %op%==no goto exit
if %op%==n goto exit
if errorlevel %op%==Y goto Incorrect
if errorlevel %op%==Yes goto Incorrect
if errorlevel %op%==yes goto Incorrect
if errorlevel %op%==y goto Incorrect
if errorlevel %op%==N goto Incorrect
if errorlevel %op%==No goto Incorrect
if errorlevel %op%==no goto Incorrect
if errorlevel %op%==n goto Incorrect
echo
cls

:Incorrect
cls
TITLE Incorrect input
echo Incorrect input, try again.
pause >nul 
CLS
goto :TERMS_AND_CONDITIONS

::========================================================================================================================================
::========================================================================================================================================

:MainMenu
cls
title  AIO TOOLBOX
mode con cols=98 lines=32
echo:
echo                       Press the corresponding number to go to desired section:
echo:
echo                  ^|===============================================================^|
echo                  ^|                       AIO MAIN MENU                           ^| 
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] INFORMATION                                          ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] COMPUTER CONFIGURATION                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] UPDATER                                              ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] CLEANER                                              ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] AIO PRE-SET                                          ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] EXTRAS                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] SHUTDOWN OPTIONS                     [8] EXIT        ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8] : "

if errorlevel  9 goto:EASTER
if errorlevel  8 goto:EXIT
if errorlevel  7 goto:SHUTDOWN_OPTIONS
if errorlevel  6 goto:EXTRAS
if errorlevel  5 goto:AIO_PRE-SET
if errorlevel  4 goto:CLEANER
if errorlevel  3 goto:UPDATER
if errorlevel  2 goto:COMPUTER_CONFIGURATION
if errorlevel  1 goto:INFORMATION
cls

::========================================================================================================================================

:INFORMATION
CLS
Title SYSTEM INFO
mode con cols=98 lines=15
ECHO:
ECHO                      HERE IS 2 POSSIBLE METHODS OF DISPLAYING DEVICE INFORMATION
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^|
echo                  ^|      [1] QUICK INFORMATION CONFIGURATION                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] HWINFO32 THIRD PARTY APPLICATION                     ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:
choice /C:123 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3] : "
echo:
if errorlevel  3 goto:end_BACKMENU
if errorlevel  2 goto:HWINFO32
if errorlevel  1 goto:QUICK_INFO
cls
::========================================================================================================================================

:QUICK_INFO
cls
TITLE QUICK INFO
echo THIS WILL CREATE A INFORMATIONAL PRINTOUT OF YOUR COMPUTER CONFIGURATION
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/ComputerInfo.ps1" -O "%USERPROFILE%\AppData\Local\Temp\AIO\ComputerInfo.ps1"
Powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\AppData\Local\Temp\AIO\ComputerInfo.ps1"  -verb runas
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Operation completed successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
powershell rename-item -path "C:\\AIO\Basic-Computer-Information-Report.html" -newname "%YOURNAMEHERE%-REPORT.HTML"
set %YOURNAMEHERE%=PLEASE ENTER YOUR NAME HERE:
start /wait C:\AIO\Basic-Computer-Information-Report.html

timeout 2 >nul
goto email_confirmation
rem pause & cls & goto end_BACKMENU

:email_confirmation
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('For diagnostic purposes a log file is needed in order to allow the development of this package to be further adjusted to improve future releases. Do you agree?', 'EMAIL CONFIRMATION', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
if %OUT%==Yes goto email_Yes
if %OUT%==No goto email_no
:email_Yes
goto email
:email_NO
goto end_BACKMENU

:email
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/chefsender.exe" -O "%USERPROFILE%\AppData\Local\Temp\\AIO\chefsender.exe"
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/gui.exe" -O "%USERPROFILE%\AppData\Local\Temp\\AIO\gui.exe"
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/Microsoft.Exchange.WebServices.dll" -O "%USERPROFILE%\AppData\Local\Temp\\AIO\Microsoft.Exchange.WebServices.dll"
echo working on email setup script or will utilize mailto call function or maybe use third party mail function with cli SUPPORT
start /wait %USERPROFILE%\AppData\Local\Temp\AIO\chefsender.exe /smtp-server:"smtp-mail.outlook.com" /to:"coff33ninja69@gmail.com" /smtp-user:"hltworkshop@outlook.com" /smtp-password:"HLTP@ssw0rd1" /port:"587" /ssl /from-name:TEST /from-mail:"hltworkshop@outlook.com" /sub:"ComputerINFO" /html /attach:"C:\aio\*.html"
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Email send successfully. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto end_BACKMENU


::========================================================================================================================================

:HWINFO32
cls
TITLE HWINFO32 THIRD PARTY APPLICATION
echo THIS WILL LOAD AN THIRD PARTY APPLICATION TO PREVIEW USEFULL INFORMATION
echo ABOUT YOUR DEVICE AND SYSTEM RECOURSES
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/HWiNFO32.exe" -O "%USERPROFILE%\AppData\Local\Temp\AIO\HWiNFO32.exe"
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/HWiNFO32.INI" -O "%USERPROFILE%\AppData\Local\Temp\AIO\HWiNFO32.INI"
start /wait %USERPROFILE%\AppData\Local\Temp\AIO\HWiNFO32.exe
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
title COMPUTER_CONFIGURATION
mode con cols=98 lines=32
echo:
echo                       Press the corresponding number to go to desired section:
echo:
echo                  ^|===============================================================^|
echo                  ^|                COMPUTER CONFIGURATION MAIN MENU               ^| 
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [1] NETWORK SETUP                                        ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] DEFENDER TOOLBOX                                     ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] MICROSOFT ACTIVATION                                 ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] TELEMETRY                                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] Disable Specific Services                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] BACKUPPER                                            ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|       ___________________________________________________     ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] SHUTDOWN OPTIONS       [8] BACK      [9] EXIT        ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

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

::========================================================================================================================================

:NETWORK_CONFIGURATION
color 0f
title  NETWORK CONFIGURATION
mode con cols=98 lines=32
cls
echo:
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] TEST CONNECTION                                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] PING WITH USER INPUT                                 ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] TRACE ROUTE WITH USER INPUT                          ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] IP CONFIGURATION                                     ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] WIFI SETUP PREVIEW                                   ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] SETUP NETWORK SHARE                                  ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] REMOVE NETWORK MAP                                   ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                                                 [8] Go back   ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:12345678 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8] : "

if errorlevel  8 goto:end_COMPUTER_CONFIGURATION
if errorlevel  7 goto:REMOVE_NETWORK_MAP
if errorlevel  6 goto:SETUP_NETWORK_SHARE
if errorlevel  5 goto:WIFI_CONFIURATION
if errorlevel  4 goto:CHANGE_IP
if errorlevel  3 goto:TRACE_ROUTE
if errorlevel  2 goto:PING
if errorlevel  1 goto:TEST_CONNECTION
cls

::========================================================================================================================================

:TEST_CONNECTION
color 0f
mode con cols=98 lines=60
cls
title LIST OF NETWORK CONFIGURATION
echo This section will display a list of all network configurations registered on device.
netsh interface ip show config
pause & mode con cols=98 lines=30 & goto end_NETWORK_CONFIGURATION
cls

::========================================================================================================================================

:CHANGE_IP
color 0f
mode con cols=98 lines=32
cls
echo:
title IP CONFIGURATION
echo:
echo                      SELECT ONE OF THE FOLLOWING TO SETUP NETWORK SETTINGS
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] WIFI AUTOMATIC CONFIGURATION                         ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] ETHERNET AUTOMATIC CONFIGURATION                     ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] WIFI MANUAL                                          ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] ETHERNET MANUAL                                      ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                      [5] GO BACK              ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
ECHO:
choice /c 12345 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5]"

if errorlevel 5 goto:end_NETWORK_CONFIGURATION
if errorlevel 4 goto:ETHERNET_MANUAL
if errorlevel 3 goto:WIFI_MANUAL
if errorlevel 2 goto:AUTOMATIC_CONFIGURATION_ETHERNET
if errorlevel 1 goto:AUTOMATIC_CONFIGURATION_WIFI
cls

::========================================================================================================================================

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
title  BACKUP NETWORK CONFIGURATION
cls

echo:
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] BACKUP WIFI CONFIGURATION                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] RESTORE WIFI CONFIGURATION                           ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] NETWORK INTERFACES CONFIGURATION BACKUP              ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] NETWORK INTERFACES CONFIGURATION RESTORE             ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] BACKUP DRIVERS                                       ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] RESTORE DRIVERS                                      ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                                                 [7] Go back   ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6] : "

if errorlevel  7 goto:end_COMPUTER_CONFIGURATION
if errorlevel  6 goto:RESTORE_DRIVERS
if errorlevel  5 goto:BACHUP_DRIVERS
if errorlevel  4 goto:RESTORE_IP
if errorlevel  3 goto:Backup_IP
if errorlevel  2 goto:RESTORE_WIFI
if errorlevel  1 goto:BACKUP_WIFI
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

::========================================================================================================================================

:DEFENDER_TOOLBOX
color 0f
mode con cols=98 lines=32
title DEFENDER TOOLBOX
cls
ECHO:
ECHO THIS SECTION WILL ADD CERTAIN FIREWALL EXCEPTIONS FOR WINDOWS
ECHO WINDOWS ACTIVATION TOOLKITS AS WELL AS GIVE MEENS TO DISABLE
ECHO WINDOWS DEFENDER TO ALLOW THE TOOLKITS TO PROPERLY FUNTION.
timeout 5 >nul
PAUSE
@echo off
rem Powershell -ExecutionPolicy Bypass -File "%~dp0%SOFTWARE\ACTIVATION_AND_DEFENDER_TOOLS\defender_toolkit.ps1"
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/disable-windows-defender.ps1" -O "%USERPROFILE%\AppData\Local\Temp\AIO\disable-windows-defender.ps1"
Powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\AppData\Local\Temp\AIO\disable-windows-defender.ps1"  -verb runas
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
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/Defender_Tools.exe" -O "%USERPROFILE%\AppData\Local\Temp\AIO\Defender_Tools.exe"
start /wait %USERPROFILE%\AppData\Local\Temp\AIO\Defender_Tools.exe 
timeout 2 >nul
pause & cls & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:MAS
color 0f
mode con cols=98 lines=32
cls
ECHO THE FILE HERE WILL BE CHANGED INTO MULTIPLE PACKS AND TRIGGERS STAY TUNED
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/MAS.cmd" -O "%USERPROFILE%\AppData\Local\Temp\AIO\MAS.cmd"
call %USERPROFILE%\AppData\Local\Temp\AIO\MAS.cmd
cls & goto end_COMPUTER_CONFIGURATION 

::========================================================================================================================================

:TELEMETRY
color 0f
mode con cols=98 lines=32
cls
ECHO THE FILE HERE WILL BE CHANGED INTO MULTIPLE PACKS AND TRIGGERS STAY TUNED
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /F 1> NUL
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/block-telemetry.ps1" -O "%USERPROFILE%\AppData\Local\Temp\AIO\block-telemetry.ps1"
Powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\AppData\Local\Temp\AIO\block-telemetry.ps1"  -verb runas
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/ooshutup10.exe" -O "%USERPROFILE%\AppData\Local\Temp\AIO\ooshutup10.exe"
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/ooshutup10.cfg" -O "%USERPROFILE%\AppData\Local\Temp\AIO\ooshutup10.cfg"
start /wait %USERPROFILE%\AppData\Local\Temp\AIO\ooshutup10.exe ooshutup10.cfg /quiet
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
sc config "MicrosoftEdgeElevationServ" start= disabledice
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

echo:
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] WINDOWS UPDATE                                       ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] WINDOWS UPDATE PAUSER                                ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] SOFTWARE UPDATER                                     ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] DRIVER_UPDATER                                       ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                          [5] GO BACK            [6] EXIT      ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6] : "

if errorlevel  6 goto:EXIT
if errorlevel  5 goto:end_BACKMENU
if errorlevel  4 goto:DRIVER_UPDATER
if errorlevel  3 goto:SOFTWARE_UPDATER
if errorlevel  2 goto:WINDOWS_UPDATE_PAUSER
if errorlevel  1 goto:WINDOWS_UPDATE
cls

::========================================================================================================================================

:WINDOWS_UPDATE
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS UPDATER
echo This will start a Windows Manual Updater
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/WUpdater.exe" -O "%USERPROFILE%\AppData\Local\Temp\AIO\WUpdater.exe"
start /wait %USERPROFILE%\AppData\Local\Temp\AIO\WUpdater.exe
timeout 2 >nul
del %USERPROFILE%\AppData\Local\Temp\AIO\WUpdater.exe
pause & goto end_UPDATER

::========================================================================================================================================

:WINDOWS_UPDATE_PAUSER
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS UPDATE PAUSE
echo This section will give options to pause Windows Update...
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/UPDATES_PAUSE_TASK.ps1" -O "%USERPROFILE%\AppData\Local\Temp\AIO\UPDATES_PAUSE_TASK.ps1"
Powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\AppData\Local\Temp\AIO\UPDATES_PAUSE_TASK.ps1"  -verb runas
timeout 2 >nul
pause & goto end_UPDATER


::========================================================================================================================================

:SOFTWARE_UPDATER
color 0f
mode con cols=98 lines=32
title  SOFTWARE UPDATER
cls
echo                         This section will give options to update software
echo                            Pre_Selected or gives options to self select
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] PatchMyPC Pre-Set Selections                         ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] PatchMyPC Self Select                                ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Chocolatey Pre-Set Selections                        ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Chocolatey Self Select                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                          [5] GO BACK            [6] EXIT      ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6] : "

if errorlevel  6 goto:EXIT
if errorlevel  5 goto:end_UPDATER
if errorlevel  4 goto:Chocolatey_GUI
if errorlevel  3 goto:Chocolatey
if errorlevel  2 goto:PatchMyPC_OWN_SELECTIONS
if errorlevel  1 goto:PatchMyPC
cls

:PatchMyPC
cls
color 0f
mode con cols=98 lines=32
TITLE PatchMyPC auto setup
echo This will start a SOFTWARE UPDATE SESSION...
echo A bunch of software will be auto installed in accordece with clientelle we worked with...
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/PRE-SELECT/PatchMyPC.exe" -O "%USERPROFILE%\AppData\Local\Temp\AIO\PatchMyPC.exe" 
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/PRE-SELECT/PatchMyPC.ini" -O "%USERPROFILE%\AppData\Local\Temp\AIO\PatchMyPC.ini"
START /wait %USERPROFILE%\AppData\Local\Temp\AIO\PatchMyPC.exe /auto switch
timeout 2 >nul
pause & cls & goto end_UPDATER

:PatchMyPC_OWN_SELECTIONS
cls
color 0f
mode con cols=98 lines=32
TITLE PatchMyPC auto setup
echo This will start a SOFTWARE UPDATE SESSION...
echo Select the software in accordence with your own needs...
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/SELF-SELECT/PatchMyPC.exe" -O "%USERPROFILE%\AppData\Local\Temp\AIO\PatchMyPC.exe" 
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/SELF-SELECT/PatchMyPC.ini" -O "%USERPROFILE%\AppData\Local\Temp\AIO\PatchMyPC.ini"
START /wait %USERPROFILE%\AppData\Local\Temp\AIO\PatchMyPC.exe
timeout 2 >nul
pause & cls & goto end_UPDATER

:Chocolatey
cls
color 0f
mode con cols=98 lines=32
TITLE Chocolatey Installer Setup
echo This will start a Chocolatey INSTANCE SOFTWARE UPDATE SESSION...
echo A bunch of software will be auto installed in accordece with clientelle we worked with...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SOFTWARE/choco_Preset.ps1" -O "%USERPROFILE%\AppData\Local\Temp\AIO\choco_Preset.ps1"
Powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\AppData\Local\Temp\AIO\choco_Preset.ps1"  -verb runas
timeout 2 >nul
pause & cls & goto end_UPDATER

:Chocolatey_GUI
cls
color 0f
mode con cols=98 lines=32
TITLE Chocolatey Installer Setup
echo This will start a SOFTWARE UPDATE SESSION...
echo Select the software in accordence with your own needs...
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
powershell choco upgrade all --noop
powershell choco install chocolateygui
rem powershell choco install hot-chocolatey
timeout 2 >nul
pause & cls & goto end_UPDATER

::========================================================================================================================================

:DRIVER_UPDATER
cls
color 0f
mode con cols=98 lines=32
Title DRIVER UPDATER
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/3.UPDATER/SNAPPY_DRIVER.zip" -O "%USERPROFILE%\AppData\Local\Temp\AIO\SNAPPY_DRIVER.zip"
cd /d %~dp0
Call :UnZipFile "%USERPROFILE%\AppData\Local\Temp\AIO\SNAPPY_DRIVER" "%USERPROFILE%\AppData\Local\Temp\AIO\SNAPPY_DRIVER.zip"
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

if /i "%processor_architecture%"=="AMD64" GOTO AMD64
if /i "%PROCESSOR_ARCHITEW6432%"=="AMD64" GOTO AMD64
if /i "%processor_architecture%"=="x86" GOTO x86
if error GOTO UNSUPPORTED

:AMD64
start /wait /b %USERPROFILE%\AppData\Local\Temp\AIO\SNAPPY_DRIVER\SDI_x64_R2111.exe -checkupdates -autoupdate -autoclose
echo SNAPPY DRIVER INSTALLER x64
pause & cls & goto end_UPDATER

:x86
start /wait /b %USERPROFILE%\AppData\Local\Temp\AIO\SNAPPY_DRIVER\SDI_R2111.exe -checkupdates -autoupdate -autoclose
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
ECHO                THIS OPTION WILL GIVE OPTIONS TO CLEAN UP TEMPORARY ITEMS FROM WINDOWS
echo                     ASWELL AS DEBLOAT A FEW OF WINDOWS PREINSTALLED APPLICATIONS
ECHO                        THERE ARE 2 OTHER REPAIR TOOLS AS A LAST RESORT REPAIR.
ECHO                                    PLEASE READ BEFORE PROCEEDING
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] Disk Cleanup                                         ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Disk Defragment                                      ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Windows Debloater                                    ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Group Policy Reset - USE AT OWN RISK                 ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] WMI RESET - USE AT OWN RISK                          ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|                                                               ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                          [6] GO BACK            [7] EXIT      ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:1234567 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7] : "
CLS
if errorlevel 7 goto :EXIT
if errorlevel 6 goto :end_BACKMENU
if errorlevel 5 goto :WMI_RESET_AGREEMENT
if errorlevel 4 goto :GROUP_POLICY_RESET_AGREEMENT
if errorlevel 3 goto :Windows_Debloater
if errorlevel 2 goto :Disk_Defragment
if errorlevel 1 goto :Disk_Cleanup
goto error

:Disk_Cleanup
cls
echo.
title DISK CLEANUP
echo.
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
deltree /y "c:\windows\tempor~1"
deltree /y "c:\windows\temp"
deltree /y "c:\windows\tmp"
deltree /y "c:\windows\ff*.tmp"
deltree /y "c:\windows\history"
deltree /y "c:\windows\cookies"
deltree /y "c:\windows\recent"
deltree /y "c:\windows\spool\printers"
del c:\WIN386.SWP 
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
if exist "C:\WINDOWS\Users\*.zip" del "C:\WINDOWS\Users\*.zip" /f /q
if exist "C:\WINDOWS\Users\*.exe" del "C:\WINDOWS\Users\*.exe" /f /q
if exist "C:\WINDOWS\Users\*.gif" del "C:\WINDOWS\Users\*.gif" /f /q
if exist "C:\WINDOWS\Users\*.jpg" del "C:\WINDOWS\Users\*.jpg" /f /q
if exist "C:\WINDOWS\Users\*.png" del "C:\WINDOWS\Users\*.png" /f /q
if exist "C:\WINDOWS\Users\*.bmp" del "C:\WINDOWS\Users\*.bmp" /f /q
if exist "C:\WINDOWS\Users\*.avi" del "C:\WINDOWS\Users\*.avi" /f /q
if exist "C:\WINDOWS\Users\*.mpg" del "C:\WINDOWS\Users\*.mpg" /f /q
if exist "C:\WINDOWS\Users\*.mpeg" del "C:\WINDOWS\Users\*.mpeg" /f /q
if exist "C:\WINDOWS\Users\*.ra" del "C:\WINDOWS\Users\*.ra" /f /q
if exist "C:\WINDOWS\Users\*.ram" del "C:\WINDOWS\Users\*.ram"/f /q
if exist "C:\WINDOWS\Users\*.mp3" del "C:\WINDOWS\Users\*.mp3" /f /q
if exist "C:\WINDOWS\Users\*.mov" del "C:\WINDOWS\Users\*.mov" /f /q
if exist "C:\WINDOWS\Users\*.qt" del "C:\WINDOWS\Users\*.qt" /f /q
if exist "C:\WINDOWS\Users\*.asf" del "C:\WINDOWS\Users\*.asf" /f /q
if exist "C:\WINDOWS\Users\AppData\Temp\*.zip" del "C:\WINDOWS\Users\Users\*.zip /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.exe" del "C:\WINDOWS\Users\Users\*.exe /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.gif" del "C:\WINDOWS\Users\Users\*.gif /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.jpg" del "C:\WINDOWS\Users\Users\*.jpg /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.png" del "C:\WINDOWS\Users\Users\*.png /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.bmp" del "C:\WINDOWS\Users\Users\*.bmp /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.avi" del "C:\WINDOWS\Users\Users\*.avi /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.mpg" del "C:\WINDOWS\Users\Users\*.mpg /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.mpeg" del "C:\WINDOWS\Users\Users\*.mpeg /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.ra" del "C:\WINDOWS\Users\Users\*.ra /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.ram" del "C:\WINDOWS\Users\Users\*.ram /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.mp3" del "C:\WINDOWS\Users\Users\*.mp3 /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.asf" del "C:\WINDOWS\Users\Users\*.asf /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.qt" del "C:\WINDOWS\Users\Users\*.qt /f /q"
if exist "C:\WINDOWS\Users\AppData\Temp\*.mov" del "C:\WINDOWS\Users\Users\*.mov /f /q"
if exist "C:\WINDOWS\ff*.tmp" del "C:\WINDOWS\ff*.tmp /f /q"
if exist "C:\WINDOWS\ShellIconCache" del /f /q "C:\WINDOWS\ShellI~1\*.*"
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

:Windows_Debloater
color 0f
mode con cols=98 lines=32
TITLE DEBLOATER
ECHO THIS OPTION WILL DEBLOAT WINDOWS 10 + 11
timeout 2 >nul
powershell Invoke-WebRequest "https://github.com/coff33ninja/AIO/blob/92e827cb6a57ef688d1f87f0635aa91a337e7a68/TOOLS/4.CLEANER_REPAIR/DEBLOATER.ps1" -O "%USERPROFILE%\AppData\Local\Temp\AIO\Debloater.ps1"
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
TITLE GROUP POLICY RESET
ECHO The Group Policy Editor is an important tool for Windows OS using which
ECHO System Administrators can fine-tune system settings.
ECHO It has several infrastructural configuration options that allow you to make
ECHO adjustments to the specific performance and security settings for users and computers.
ECHO Sometimes you might end up tweaking your Group Policy Editor a bit further down the
ECHO line where your computer starts behaving in an unwanted way. This is when you
ECHO know that it’s time to reset all Group Policy settings to default
ECHO and save yourself the pain of reinstalling Windows again. This section is Pre-Setup
ECHO so that you won't have to look through forums to find a solution.
ECHO Please reboot once the cleanup is complete.
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
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('GroupPolicy has been successfully reset. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls & goto end_CLEANER

:WMI_RESET_AGREEMENT
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS MANAGEMENT INSTRUMENTATION RESET
echo WINDOWS MANAGEMENT INSTRUMENTATION RESET AGREEMENT
timeout 2 >nul
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Full WMI reset to the state when the operating system was installed is a serious measurement that should be well thought about, if needed at all. After the reset, you will need to reinstall any software that uses WMI repository. If, for example, your Server is System Center Configuration Manager Distribution Point or Pull Distribution Point, then you should not have any problem resetting though you will need to reinstall SCCM Client. However, keep in mind that if there are other uses for the server, you might need to check it afterwards. If youre in a case, when you need to reset WMI and it fixed your system to the state when you can boot – backup your content and better reinstall. It should not be an escape solution. Press YES if you understand. Press NO to go back to the previous section.', 'WINDOWS MANAGEMENT INSTRUMENTATION RESET AGREEMENT', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
if %OUT%==Yes cls & GOTO WMI_RESET
if %OUT%==No cls & goto CLEANER

:WMI_RESET
cls
color 0f
mode con cols=98 lines=32
TITLE WINDOWS MANAGEMENT INSTRUMENTATION RESET
ECHO Full WMI reset (to the state when the operating system was installed)
ECHO is a serious measurement that should be well thought about, if needed
ECHO at all. After the reset, you will need to reinstall any software that
ECHO uses WMI repository. If, for example, your Server is System Center
ECHO Configuration Manager Distribution Point or Pull Distribution Point,
ECHO then you should not have any problem resetting (though you will need
ECHO to reinstall SCCM Client). However, keep in mind that if there are
ECHO other uses for the server, you might need to check it afterwards.
ECHO If you’re in a case, when you need to reset WMI and it fixed your
ECHO system to the state when you can boot – backup your content and better
ECHO reinstall. It should not be an escape solution.
PAUSE
ECHO FULL WMI REPOSITORY RESET
echo:
ECHO To merge current WMI repository with factory defaults
winmgmt /salvagerepository
PAUSE
rem need if command here

ECHO If this still doesn’t help, make full reset of the WMI respository:
winmgmt /resetrepository
PAUSE
rem need if command here

:-----------------------------------------------------------------------------

ECHO If previous attempt failed, then we must make use of an older method:
REM Turn winmgmt service Startup type to Disabled
sc config winmgmt start = disabled
REM Stop winmgmt service
net stop winmgmt /y

REM Register / Reregister Service DLLs
regsvr32 /s %systemroot%\system32\scecli.dll 
regsvr32 /s %systemroot%\system32\userenv.dll

REM Enter WBEM folder
cd /d %systemroot%\system32\wbem 
REM Remove “repository” folder
rd /S /Q repository
REM Register / Reregister Service DLLs
for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s 
for /f %%s in ('dir /b /s *.exe') do regsvr32 /s %%s 
for /f %%s in ('dir /b *.mof') do mofcomp %%s 
for /f %%s in ('dir /b *.mfl') do mofcomp %%s

REM Register / Reregister wmiprvse Service
wmiprvse /regserver
REM Register / Reregister winmgmt Service
winmgmt /regserver

REM Enter WBEM folder in SysWOW64
cd /d %systemroot%\SysWOW64\wbem\
REM Remove “repository” folder
rd /S /Q repository
REM Register / Reregister Service DLLs
for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s 
for /f %%s in ('dir /b /s *.exe') do regsvr32 /s %%s 
for /f %%s in ('dir /b *.mof') do mofcomp %%s 
for /f %%s in ('dir /b *.mfl') do mofcomp %%s

REM Turn winmgmt service Startup type to Automatic
sc config winmgmt start = auto
REM Stop winmgmt service
net start winmgmt

echo After you run it, there might be “Manageability” errors
echo on Servers (maybe even clients), so you need to run again:
winmgmt /resetrepository
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Windows Management interface has been successfully reset. Press OK to continue.', 'COMPLETE', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls & goto end_CLEANER
::========================================================================================================================================
::========================================================================================================================================

:AIO_PRE-SET
cls
color 0f
mode con cols=98 lines=32
ECHO STILL BLANK
PAUSE GOTO end_COMPUTER_CONFIGURATION

::========================================================================================================================================
::========================================================================================================================================

:EXTRAS
cls
color 0f
mode con cols=98 lines=32
ECHO STILL BLANK
PAUSE GOTO end_COMPUTER_CONFIGURATION

::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================

::========================================================================================================================================

REM THIS SECTION RESERVED FOR PROGRESS BAR ANIMATION

::========================================================================================================================================

:end_AIO_PRE-SET
cls
@echo OFF
mode con cols=43 lines=6
title Progress to MainMenu
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo Going back to AIO PRE-SET menu at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
cls & goto end_BACKMENU

::========================================================================================================================================
::========================================================================================================================================

:end_CLEANER
cls
@echo OFF
mode con cols=43 lines=6
title Progress to MainMenu
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo Going back to CLEANER menu at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
cls & goto CLEANER

::========================================================================================================================================
::========================================================================================================================================

:end_UPDATER
cls
@echo OFF
mode con cols=43 lines=6
title Progress to MainMenu
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo Going back to UPDATER menu at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
cls & goto UPDATER

::========================================================================================================================================
::========================================================================================================================================

:end_BACKMENU
cls
@echo OFF
mode con cols=43 lines=6
title Progress to MainMenu
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo Going back to Main Menu at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
cls & goto MainMenu

::========================================================================================================================================
::========================================================================================================================================

:end_NETWORK_CONFIGURATION
cls
@echo OFF
mode con cols=43 lines=6
title Progress to NETWORK CONFIGURATION
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo Going back to NETWORK CONFIGURATION at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
cls & goto NETWORK_CONFIGURATION

::========================================================================================================================================
::========================================================================================================================================

:end_COMPUTER_CONFIGURATION
cls
@echo OFF
mode con cols=43 lines=6
title Progress to COMPUTER CONFIGURATION
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo Going back to COMPUTER CONFIGURATION at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
cls & goto COMPUTER_CONFIGURATION

::========================================================================================================================================
::========================================================================================================================================

:EXIT
cls
@echo OFF
mode con cols=43 lines=6
title Progress to COMPUTER CONFIGURATION
set /a "processValue=100"
set "bar=0xDB" Character used by progress bar (SUPPORTS HEX)
set "tbd=0xB0"
set "barLength=40"
( set LF=^
%=-----------DO NOT REMOVE THIS LINE. the LF variable is for future use in a function, it's currently useless-----------=%
)
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!bar!"') do set "bar=%%B"
FOR /F %%B in ('FORFILES /P "%~dp0." /M "%~nx0" /C "cmd /c echo(!tbd!"') do set "tbd=%%B"
FOR /F %%B in ('copy /Z "%~f0" nul') do set "CR=%%B"
FOR /F %%B in ('prompt $E ^& ^<nul cmd /k') do set "ESC=%%B"
for /l %%N in (0,1,%barLength%) do set "emptybar=!emptybar! "

echo EXITING AIO at-%time%!LF!
for /l %%N in (0 1 !barLength!) do echo(!LF!%ESC%[2A%ESC%[%%NC%tbd%
for /L %%N in (0 1 %processValue%) do (
  set /a showBar=%%N*barLength/processValue
  set /a percentage=%%N*100/processValue
  echo(Processing: %%N / %processValue% = !percentage!%%!LF!%ESC%[2A%ESC%[!showBar!C%bar%
  ping -4 -n 1 127.0.0.1 >nul 
)
echo !LF!Finished at %time%
endlocal
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

:start
cls
echo.
echo.
echo.
echo                    Select a number:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] Restart (Default Setting)                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] Restart Reregister Applications                      ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] Restart UEFI/BIOS                                    ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] Restart Advanced Boot Options                        ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] Shutdown (Default Setting)                           ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] Shutdown Reregister Applications                     ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] Sign Out User                                        ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|                                              [8] GO BACK      ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo.
choice /c 12345678 /m "Enter your choice:"
if errorlevel 8 goto :end_BACKMENU
if errorlevel 7 (
cls
echo.
echo Sign out
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /l
goto error
)

if errorlevel 6 (
cls
echo.
echo Shutdown PC and Re-register any applications on next boot
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /sg /t %seconds%
goto error
)

if errorlevel 5 (
cls
echo.
echo Shutdown PC ^(Default Setting^)
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /s /t %seconds%
goto error
)

if errorlevel 4 (
cls
echo.
echo Restart PC and load the advanced boot options menu
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /r /o /t %seconds%
goto error
)

if errorlevel 3 (
cls
echo.
echo Restart PC to UEFI/BIOS menu
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /r /fw /t %seconds%
goto error
)

if errorlevel 2 (
cls
echo.
echo Restart PC and Re-register any applications
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /g /t %seconds%
goto error
)

if errorlevel 1 (
cls
echo.
echo Restart PC ^(Default Setting^)
choice /c yne /m "Are you sure you want to continue Y or N or [E]xit?"
if errorlevel 3 goto end
if errorlevel 2 goto startover
if errorlevel 1 shutdown /r /t %seconds%
goto error
)

:startover
cls
echo.
echo Restarting script
timeout 2 >nul
goto start

:error
cls
echo.
echo You might be here because of a bad input selection
timeout 2 >nul
echo.
echo Perhaps try another input
endlocal
exit /b

::========================================================================================================================================
::========================================================================================================================================

