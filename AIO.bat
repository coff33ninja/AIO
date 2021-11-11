@echo off
setlocal
%SystemRoot%\System32\rundll32.exe shell32.dll,SHCreateLocalServerRunDll {c82192ee-6cb5-4bc0-9ef0-fb818773790a}
CLS

::========================================================================================================================================

cls
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
title  TEST BOXES
mode con cols=98 lines=32
echo:
echo                       Press the corresponding number to go to desired section:
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] NETWORK CONFIGURATION                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] COMPUTER CONFIGURATION                               ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] SYSTEM INFO                                          ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] SHUTDOWN OPTIONS                     [8] EXIT        ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8] : "

if errorlevel  9 goto:STARWARS
if errorlevel  8 goto:EXIT
if errorlevel  7 goto:SHUTDOWN_OPTIONS
if errorlevel  6 goto:SYS_INFO
if errorlevel  5 goto:TEST_UNKNOWN
if errorlevel  4 goto:TEST_UNKNOWN
if errorlevel  3 goto:TEST_UNKNOWN
if errorlevel  2 goto:COMPUTER_CONFIGURATION
if errorlevel  1 goto:NETWORK_CONFIGURATION
cls

::========================================================================================================================================

::========================================================================================================================================

:NETWORK_CONFIGURATION
color 0f
title  NETWORK CONFIGURATION
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

if errorlevel  9 goto:MainMenu
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
pause & mode con cols=98 lines=30 & goto NETWORK_CONFIGURATION
cls

::-------------------------------------------------------------------------------------------------------

:CHANGE_IP
color 0f
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

if errorlevel 5 goto:NETWORK_CONFIGURATION
if errorlevel 4 goto:ETHERNET_MANUAL
if errorlevel 3 goto:WIFI_MANUAL
if errorlevel 2 goto:AUTOMATIC_CONFIGURATION_ETHERNET
if errorlevel 1 goto:AUTOMATIC_CONFIGURATION_WIFI
cls

:AUTOMATIC_CONFIGURATION_WIFI
color 0f
title WIFI AUTOMATIC CONFIGURATION
cls
echo:
netsh interface ipv4 set address name="Wi-Fi" source=dhcp
netsh interface ipv4 set dnsservers name"Wi-Fi" source=dhcp
pause & cls & ping google.com & goto NETWORK_CONFIGURATION

:AUTOMATIC_CONFIGURATION_ETHERNET
color 0f
title ETHERNET AUTOMATIC CONFIGURATION
cls
echo:
netsh interface ipv4 set address name="Ethernet" source=dhcp
netsh interface ipv4 set dnsservers name"Ethernet" source=dhcp
pause & cls & ping google.com & goto NETWORK_CONFIGURATION

:WIFI_MANUAL
color 0f
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
pause & cls & ping google.com & goto NETWORK_CONFIGURATION

:ETHERNET_MANUAL
color 0f
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
pause & cls & ping google.com & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:PING
color 0f
cls
echo:
echo EXAMPLES
echo 8.8.8.8 for GOOGLE
echo 1.1.1.1 for CLOUDFLARE
echo:
Set /P pinghost=Enter an IP address or hostname to ping:
ping.exe %pinghost% -t
pause & cls & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:TRACE_ROUTE
color 0f
cls
Set /P config=Enter an IP address or hostname to trace:
tracert.exe -d -h 64 %config%
pause & cls & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:SETUP_NETWORK_SHARE
color 0f
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
pause & ping %COMPUTER_NAME% & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:REMOVE_NETWORK_MAP
color 0f
cls
echo:
title REMOVE NETWORK MAP
net use %REMOVELETTER%: /delete
Set /P %REMOVELETTER%=ENTER MAPPED DRIVE LETTER TO REMOVE:
pause & cls & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:WIFI_CONFIURATION
setlocal enabledelayedexpansion
cls
ECHO:
title WiFi name list
echo This section will display all registered WIFI networks on this device.
echo Use PageUp or PageDown to scroll if needed item does not display.
netsh wlan show profile
pause & goto WiFi_prompt
if error "There is no wireless interface on the system." goto WiFiNo

:WiFi_prompt
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
cls & goto NETWORK_CONFIGURATION

:WiFiNo
cls & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:BACKUP_CONFIG
color 0f
title  BACKUP NETWORK CONFIGURATION
cls

echo:
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] BACKUP WIFI CONFIGURATION                           ^|
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

if errorlevel  9 goto:NETWORK_CONFIGURATION
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
cls
echo
md C:\WIFI
echo This will backup the WiFi config to C:\WIFI
netsh wlan export profile key=clear folder=C:\wifi
cd c:\wifi
start .
pause & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------
:RESTORE_WIFI
cls
echo
cd C:\WIFI
dir
netsh wlan add profile filename="c:\wifi\%WIFINAME%.xml" user=all
echo Enter complete file name excluding .xml
echo exapmle: WIFI-TSUNAMI
echo the .xml will be added automatically
Set /P %WIFINAME%=ENTER PEVIEWED WIFI NAME TO ADD WIFI BACK:
pause & goto NETWORK_CONFIGURATION

::-------------------------------------------------------------------------------------------------------


::========================================================================================================================================

::========================================================================================================================================

:COMPUTER_CONFIGURATION
cls
title  COMPUTER CONFIGURATION
echo:
mode con cols=98 lines=32

echo:
echo                      Press the corresponding number to go to desired section:
echo:
echo                  ^|===============================================================^|
echo                  ^|                                                               ^| 
echo                  ^|                                                               ^|
echo                  ^|      [1] DEFENDER TOOLS                                       ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] WINDOWS AND OFFICE ACTIVATION                        ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] DEBLOATER                                            ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] UPDATE APPLICATIONS                                  ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] WINDOWS CLEANUP                                      ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] BLANK         [8] BLANK         [9] GO BACK          ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:end
if errorlevel  8 goto:TEST_UNKNOWN
if errorlevel  7 goto:TEST_UNKNOWN
if errorlevel  6 goto:TEST_UNKNOWN
if errorlevel  5 goto:PC_Cleanup_Utility
if errorlevel  4 goto:UPDATE_APPS
if errorlevel  3 goto:DEBLOATER
if errorlevel  2 goto:MSACTIVATION
if errorlevel  1 goto:DEFENDER_TOOLS
cls


::-------------------------------------------------------------------------------------------------------

:DEFENDER_TOOLS
title DEFENDER TOOLS
cls
ECHO:
ECHO THIS SECTION WILL ADD CERTAIN FIREWALL EXCEPTIONS FOR WINDOWS
ECHO WINDOWS ACTIVATION TOOLKITS AS WELL AS GIVE MEENS TO DISABLE
ECHO WINDOWS DEFENDER TO ALLOW THE TOOLKITS TO PROPERLY FUNTION.
timeout 5 >nul
PAUSE
@echo off
rem Powershell -ExecutionPolicy Bypass -File "%~dp0%SOFTWARE\ACTIVATION_AND_DEFENDER_TOOLS\defender_toolkit.ps1"
Powershell -ExecutionPolicy Bypass -File "%~dp0%SOFTWARE\ACTIVATION_AND_DEFENDER_TOOLS\disable-windows-defender.ps1"
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
start %~dp0\SOFTWARE\ACTIVATION_AND_DEFENDER_TOOLS\Defender_Tools.exe
popd
timeout 2 >nul
endlocal
pause & cls & goto COMPUTER_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:MSACTIVATION
echo
cls
title  Microsoft Activation Scripts AIO 1.4
ECHO THIS WILL EXIT AIO TO REOPEN MAS IF OTHER ITEMS NEEDS ATTENTION PLEASE RELAUNCH AIO
timeout 5 >nul
%~dp0\SOFTWARE\ACTIVATION_AND_DEFENDER_TOOLS\MAS.CMD

::-------------------------------------------------------------------------------------------------------

:DEBLOATER
CLS
TITLE DEBLOATER
ECHO THIS OPTION WILL DEBLOAT WINDOWS 10 + 11
timeout 2 >nul
Powershell -ExecutionPolicy Bypass -File %~dp0\SOFTWARE\CLEANUP\Debloater.ps1
timeout 2 >nul
pause & cls & goto COMPUTER_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:UPDATE_APPS
Title UPDATE APPLICATIONS
ECHO:
ECHO THIS OPTION WILL START PATCH MY PC.
timeout 2 >nul
START %~dp0\SOFTWARE\UPDATE_SOFTWARE\PatchMyPC.exe /auto switch
timeout 2 >nul
pause & cls & goto COMPUTER_CONFIGURATION

::-------------------------------------------------------------------------------------------------------

:PC_Cleanup_Utility
CLS
TITLE PC Cleanup Utility
ECHO THIS OPTION WILL GIVE OPTIONS TO CLEAN UP TEMPORARY ITEMS FROM WINDOWS
echo.
echo --------------------------------------------------------------------------------
echo PC Cleanup Utility
echo --------------------------------------------------------------------------------
echo.
echo Select a tool
echo =============
echo.
echo [1] Disk Cleanup
echo [2] Disk Defragment
echo [3] MainMenu
echo.
choice /C:123 /N /M "
if errorlevel 3 goto :COMPUTER_CONFIGURATION
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
echo Disk Cleanup successful!
echo.
pause & cls & goto PC_Cleanup_Utility

:Disk_Defragment
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
echo Disk Defrag successful!
echo.
pause & goto PC_Cleanup_Utility

::-------------------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------------------

::========================================================================================================================================

::========================================================================================================================================

:TEST_UNKNOWN
color 0D
cls
echo This still needs some work and items to address
pause & cls & goto end

::========================================================================================================================================

::========================================================================================================================================

:SYS_INFO
CLS
Title SYSTEM INFORMATION
ECHO:
ECHO    THIS OPTION DETAILS WINDOWS, HARDWARE, AND NETWORKING CONFIGURATION.
TITLE My System Info
ECHO Please wait... Checking system information.
timeout 5 >nul
pause
:: Section 1: Windows information
ECHO ==========================
ECHO WINDOWS INFO
ECHO ============================
systeminfo | findstr /c:"OS Name"
systeminfo | findstr /c:"OS Version"
systeminfo | findstr /c:"System Type"
:: Section 2: Hardware information.
ECHO ============================
ECHO HARDWARE INFO
ECHO ============================
systeminfo | findstr /c:"Total Physical Memory"
wmic cpu get name
wmic diskdrive get name,model,size
wmic path win32_videocontroller get name
:: Section 3: Networking information.
ECHO ============================
ECHO NETWORK INFO
ECHO ============================
ipconfig | findstr IPv4
ipconfig | findstr IPv6
PAUSE & CLS & GOTO MainMenu

::========================================================================================================================================

:SHUTDOWN_OPTIONS
title Shutdown Script
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

:end
cls
@echo OFF
mode con cols=43 lines=6
title Progress bar
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

::========================================================================================================================================

:EXIT
color 0c
cls
@echo OFF
mode con cols=55 lines=6
title Progress bar
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

:STARWARS
cls
title STARWARS
%~dp0\SOFTWARE\EASTER_EGG\BattleScript.bat
timeout 5 >nul
pause & cls & goto EXIT
