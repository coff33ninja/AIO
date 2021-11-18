@echo OFF
setlocal
%SystemRoot%\System32\rundll32.exe shell32.dll,SHCreateLocalServerRunDll {c82192ee-6cb5-4bc0-9ef0-fb818773790a}
CLS
MD c:\AIO
echo. > c:\AIO\log.txt

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

:TERMS_AND_CONDITIONS_AGREEMENT
if exist c:/aio/tos.txt goto MainMenu
if errorlevel goto TERMS_AND_CONDITIONS
cls

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
echo           AIO version - 1.3
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
echo               but not limited to github projects by Builtbybel, massgravel and slapanav
echo           [X] 
echo           [X] 
echo.
set /p op=      Do you agree to the terms and conditions as stated above? (Yes or No):
if %op%==Y goto MainMenu >> c:\AIO\ACCEPTEDTOS.txt
if %op%==Yes goto MainMenu >> c:\AIO\ACCEPTEDTOS.txt
if %op%==yes goto MainMenu >> c:\AIO\ACCEPTEDTOS.txt
if %op%==y goto MainMenu >> c:\AIO\ACCEPTEDTOS.txt
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

:Incorrect input, try again.
cls
TITLE Incorrect input
echo Incorrect input, try again.
pause >nul 
CLS
goto :TERMS_AND_CONDITIONS

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
Title SYSTEM INFORMATION
ECHO:
ECHO    THIS OPTION DETAILS WINDOWS, HARDWARE, AND NETWORKING CONFIGURATION.
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/HWiNFO32.exe" -O "C:\AIO\HWiNFO32.exe"
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/1.INFORMATION/HWiNFO32.INI" -O "C:\AIO\HWiNFO32.INI"
start /wait c:\aio\HWiNFO32.exe
timeout 2 >nul
GOTO TEST_CONNECTION

::-------------------------------------------------------------------------------------------------------

:TEST_CONNECTION
color 0f
mode con cols=98 lines=60
cls
title LIST OF NETWORK CONFIGURATION
echo This section will display a list of all network configurations registered on the device. > c:\fAIO\log.txt 
ECHO:
Echo %Date% %Time% >> c:\AIO\log.txt
ECHO:
netsh interface ip show config
netsh interface ip show config >> c:\AIO\log.txt
pause & GOTO MainMenu

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
echo                  ^|            ####                       ####                    ^|
echo                  ^|            ####                       ####                    ^|
echo                  ^|                       ##      ##                              ^|
echo                  ^|                         #    #                                ^|
echo                  ^|     #                     ##                              #   ^|
echo                  ^|      #___________________________________________________#    ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] SHUTDOWN OPTIONS       [6] BACK      [7] EXIT        ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:1234567 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7] : "

if errorlevel  7 goto:EXIT
if errorlevel  6 goto:end_BACKMENU
if errorlevel  5 goto:SHUTDOWN_OPTIONS
if errorlevel  4 goto:TELEMETRY 
if errorlevel  3 goto:MAS
if errorlevel  2 goto:DEFENDER_TOOLBOX
if errorlevel  1 goto:NETWORK_CONFIGURATION
cls

::-------------------------------------------------------------------------------------------------------

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
echo                  ^|      [8] NETWORK BACKUP                         [9] Go back   ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:end_COMPUTER_CONFIGURATION
if errorlevel  8 goto:BACKUP_CONFIG
if errorlevel  7 goto:REMOVE_NETWORK_MAP
if errorlevel  6 goto:SETUP_NETWORK_SHARE
if errorlevel  5 goto:WIFI_CONFIURATION
if errorlevel  4 goto:CHANGE_IP
if errorlevel  3 goto:TRACE_ROUTE
if errorlevel  2 goto:PING
if errorlevel  1 goto:TEST_CONNECTION
cls

::-------------------------------------------------------------------------------------------------------

:TEST_CONNECTION
color 0f
mode con cols=98 lines=60
cls
title LIST OF NETWORK CONFIGURATION
echo This section will display a list of all network configurations registered on device.
netsh interface ip show config
pause & mode con cols=98 lines=30 & goto end_NETWORK_CONFIGURATION
cls

::-------------------------------------------------------------------------------------------------------

:CHANGE_IP
color 0f
mode con cols=98 lines=60
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

::-------------------------------------------------------------------------------------------------------

:AUTOMATIC_CONFIGURATION_WIFI
color 0f
mode con cols=98 lines=60
title WIFI AUTOMATIC CONFIGURATION
cls
echo:
netsh interface ipv4 set address name="Wi-Fi" source=dhcp
netsh interface ipv4 set dnsservers name"Wi-Fi" source=dhcp
pause & cls & ping google.com & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:AUTOMATIC_CONFIGURATION_ETHERNET
color 0f
mode con cols=98 lines=60
title ETHERNET AUTOMATIC CONFIGURATION
cls
echo:
netsh interface ipv4 set address name="Ethernet" source=dhcp
netsh interface ipv4 set dnsservers name"Ethernet" source=dhcp
pause & cls & ping google.com & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:WIFI_MANUAL
color 0f
mode con cols=98 lines=60
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

::-------------------------------------------------------------------------------------------------------

:ETHERNET_MANUAL
color 0f
mode con cols=98 lines=60
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

::-------------------------------------------------------------------------------------------------------

:PING
color 0f
mode con cols=98 lines=60
cls
echo:
echo EXAMPLES
echo 8.8.8.8 for GOOGLE
echo 1.1.1.1 for CLOUDFLARE
echo:
Set /P pinghost=Enter an IP address or hostname to ping:
ping.exe %pinghost% -t
pause & cls & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:TRACE_ROUTE
color 0f
mode con cols=98 lines=60
cls
Set /P config=Enter an IP address or hostname to trace:
tracert.exe -d -h 64 %config%
pause & cls & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:SETUP_NETWORK_SHARE
color 0f
mode con cols=98 lines=60
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

::-------------------------------------------------------------------------------------------------------

:REMOVE_NETWORK_MAP
color 0f
mode con cols=98 lines=60
cls
echo:
title REMOVE NETWORK MAP
net use %REMOVELETTER%: /delete
Set /P %REMOVELETTER%=ENTER MAPPED DRIVE LETTER TO REMOVE:
pause & cls & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:WIFI_CONFIURATION
setlocal enabledelayedexpansion
color 0f
mode con cols=98 lines=60
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
echo.
echo To view the WiFi password note down the name and press Y to continue,
echo If not then press N to go back to previous menu.
echo.
set /p menu="Do you want to continue? (Y/N): "
if %menu%==Y goto WiFiYes
if %menu%==y goto WiFiYes
if %menu%==N goto WiFiNo
if %menu%==n goto WiFiNo
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

::-------------------------------------------------------------------------------------------------------

:BACKUP_CONFIG
color 0f
mode con cols=98 lines=60
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
echo                  ^|      [3] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [8] BLANK                                  [9] Go back   ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:end_NETWORK_CONFIGURATION
if errorlevel  8 goto:TEST_UNKNOWN
if errorlevel  7 goto:TEST_UNKNOWN
if errorlevel  6 goto:TEST_UNKNOWN
if errorlevel  5 goto:TEST_UNKNOWN
if errorlevel  4 goto:TEST_UNKNOWN
if errorlevel  3 goto:TEST_UNKNOWN
if errorlevel  2 goto:RESTORE_WIFI
if errorlevel  1 goto:BACKUP_WIFI
cls

::-------------------------------------------------------------------------------------------------------

:BACKUP_WIFI
color 0f
mode con cols=98 lines=60
cls
echo
md C:\WIFI
echo This will backup the WiFi config to C:\WIFI
netsh wlan export profile key=clear folder=C:\wifi
cd c:\wifi
start .
pause & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:RESTORE_WIFI
color 0f
mode con cols=98 lines=60
cls
echo
cd C:\WIFI
dir
netsh wlan add profile filename="c:\wifi\%WIFINAME%.xml" user=all
echo Enter complete file name excluding .xml
echo exapmle: WIFI-TSUNAMI
echo the .xml will be added automatically
Set /P %WIFINAME%=ENTER PEVIEWED WIFI NAME TO ADD WIFI BACK:
pause & goto end_NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:DEFENDER_TOOLBOX
color 0f
mode con cols=98 lines=60
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
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/disable-windows-defender.ps1" -O "c:\aio\disable-windows-defender.ps1"
Powershell -ExecutionPolicy Bypass -File "c:\aio\disable-windows-defender.ps1"
del "c:\aio\disable-windows-defender.ps1"
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
Add-MpPreference -ExclusionPath C:\WINDOWS\Temp\_MAS; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\BIN\cleanosppx64.exe; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\BIN\cleanosppx86.exe; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\Activate.cmd; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\Info.txt; ^
Add-MpPreference -ExclusionPath C:\ProgramData\Online_KMS_Activation\Activate.cmd;
@echo off
CLS
ECHO NOW THE DEFENDER DISABLE APPLICATION WILL LOAD CLOSE IF NOT NEEDED
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/Defender_Tools.exe" -O "c:\aio\Defender_Tools.exe"
start /wait c:\aio\Defender_Tools.exe 
timeout 2 >nul
del "c:\aio\Defender_Tools.exe"
endlocal
pause & cls & goto end_COMPUTER_CONFIGURATION

::========================================================================================================================================

:TELEMETRY
color 0f
mode con cols=98 lines=60
ECHO THE FILE HERE WILL BE CHANGED INTO MULTIPLE PACKS AND TRIGGERS STAY TUNED
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/TOOLS/2.COMPUTER_CONFIGURATION/TELEMETRY.bat" -O "c:\aio\TELEMETRY.bat"
start c:\aio\TELEMETRY.bat
PAUSE 
::========================================================================================================================================

:UPDATER
color 0f
mode con cols=98 lines=60
ECHO STILL BLANK
PAUSE GOTO end_COMPUTER_CONFIGURATION

::========================================================================================================================================
:CLEANER
color 0f
mode con cols=98 lines=60
ECHO STILL BLANK
PAUSE GOTO end_COMPUTER_CONFIGURATION

::========================================================================================================================================
:AIO_PRE-SET
color 0f
mode con cols=98 lines=60
ECHO STILL BLANK
PAUSE GOTO end_COMPUTER_CONFIGURATION

::========================================================================================================================================
:EXTRAS
color 0f
mode con cols=98 lines=60
ECHO STILL BLANK
PAUSE GOTO end_COMPUTER_CONFIGURATION

::========================================================================================================================================

::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================




























































::========================================================================================================================================
REM THIS SECTION DOES NOT NEED ANY EDITING
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
if errorlevel 8 goto :end
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
REM THIS SECTION RESERVED FOR PROGRESS BAR ANIMATION
::========================================================================================================================================

:end_BACKMENU
cls
@echo OFF
mode con cols=43 lines=6
title Progress to MainMenu
echo Going back to previous menu please wait...
echo ========================================
echo ^|                                ^|   0 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##                              ^|   5 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|####                            ^|  15 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|########                        ^|  30 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########                      ^|  42 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########                      ^|  45 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|############                    ^|  47 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############                  ^|  50 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|################                ^|  52 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##################              ^|  53 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|####################            ^|  65 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|######################          ^|  70 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########################      ^|  80 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|############################    ^|  89 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############################  ^|  90 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############################  ^|  95 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|################################^| 100 ^|
echo ========================================
echo OK!
cls
echo.
endlocal
cls & goto MainMenu

::========================================================================================================================================

:end_NETWORK_CONFIGURATION
cls
@echo OFF
mode con cols=43 lines=6
title Progress to NETWORK CONFIGURATION
echo Going back to previous menu please wait...
echo ========================================
echo ^|                                ^|   0 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##                              ^|   5 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|####                            ^|  15 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|########                        ^|  30 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########                      ^|  42 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########                      ^|  45 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|############                    ^|  47 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############                  ^|  50 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|################                ^|  52 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##################              ^|  53 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|####################            ^|  65 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|######################          ^|  70 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########################      ^|  80 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|############################    ^|  89 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############################  ^|  90 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############################  ^|  95 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|################################^| 100 ^|
echo ========================================
echo OK!
cls
echo.
endlocal
cls & goto NETWORK_CONFIGURATION
::========================================================================================================================================

:end_COMPUTER_CONFIGURATION
cls
@echo OFF
mode con cols=43 lines=6
title Progress to COMPUTER CONFIGURATION
echo Going back to previous menu please wait...
echo ========================================
echo ^|                                ^|   0 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##                              ^|   5 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|####                            ^|  15 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|########                        ^|  30 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########                      ^|  42 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########                      ^|  45 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|############                    ^|  47 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############                  ^|  50 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|################                ^|  52 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##################              ^|  53 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|####################            ^|  65 ^|
echo ========================================
ping localhost -n 2 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|######################          ^|  70 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##########################      ^|  80 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|############################    ^|  89 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############################  ^|  90 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|##############################  ^|  95 ^|
echo ========================================
ping localhost -n 1 >nul
cls
echo Going back to previous menu please wait...
echo ========================================
echo ^|################################^| 100 ^|
echo ========================================
echo OK!
cls
echo.
endlocal
cls & goto COMPUTER_CONFIGURATION

::========================================================================================================================================
:EXIT
cls
TITLE Cleanup
echo CLEANING UP RESIDUE LEFT OF AIO RESIDUE
forfiles -p "C:\AIO" -s -m *.bat*  /C "cmd /c del @path"
forfiles -p "C:\AIO" -s -m *.cmd*  /C "cmd /c del @path"
forfiles -p "C:\AIO" -s -m *.ps1*  /C "cmd /c del @path"
forfiles -p "C:\AIO" -s -m *.exe*  /C "cmd /c del @path"
forfiles -p "C:\AIO" -s -m *.txt*  /C "cmd /c del @path"
forfiles -p "C:\AIO" -s -m *.ini*  /C "cmd /c del @path"
goto EXIT_BAR

:EXIT_BAR
@echo OFF
CLS
color 0c
mode con cols=55 lines=6
title EXITING...
ECHO:
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|                                           ^|   0 ^|
echo ===================================================
ping localhost -n 2 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##                              ^|   5 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|###                                        ^|  15 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|#########                                 ^|  30 ^|
echo ===================================================
ping localhost -n 2 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|###############                            ^|  42 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##################                         ^|  45 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|########################                    ^|  47 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##########################                  ^|  50 ^|
echo ===================================================
ping localhost -n 2 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|#############################               ^|  52 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##############################              ^|  53 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|################################            ^|  65 ^|
echo ===================================================
ping localhost -n 2 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##################################          ^|  70 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|######################################      ^|  80 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|########################################    ^|  89 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##########################################  ^|  90 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|##########################################  ^|  95 ^|
echo ===================================================
ping localhost -n 1 >nul
cls
echo This Is a work of fiction and will exit promptly...
echo ===================================================
echo ^|############################################^| 100 ^|
echo ===================================================
echo OK!
cls
echo.
endlocal
cls & exit
::========================================================================================================================================

::========================================================================================================================================
REM THIS SECTION RESERVED FOR A FEW INTRESTING ITEMS
::========================================================================================================================================
:EASTER
::========================================================================================================================================
