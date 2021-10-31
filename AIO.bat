@echo off
setlocal EnableDelayedExpansion
color 0f
%SystemRoot%\System32\rundll32.exe shell32.dll,SHCreateLocalServerRunDll {c82192ee-6cb5-4bc0-9ef0-fb818773790a}

::========================================================================================================================================

::========================================================================================================================================

:MainMenu

cls
title  TEST BOXES
echo:
echo                    Press the corresponding number to go to desired section:
color 0f
mode con cols=98 lines=32

echo:
echo                      Press the corresponding number to go to desired section:
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
echo                  ^|      [6] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] SHUTDOWN OPTIONS   [8] STARWARS      [9] EXIT        ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:EXIT
if errorlevel  8 goto:STARWARS
if errorlevel  7 goto:SHUTDOWN_OPTIONS
if errorlevel  6 goto:TEST_UNKNOWN
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
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] SETUP NETWORK SHARE                                  ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] REMOVE NETWORK MAP                                   ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] BLANK           [8] BLANK              [9] Go back   ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:end
if errorlevel  8 goto:TEST_UNKNOWN
if errorlevel  7 goto:TEST_UNKNOWN
if errorlevel  6 goto:REMOVE_NETWORK_MAP
if errorlevel  5 goto:SETUP_NETWORK_SHARE
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
ECHO:
title IP CONFIGURATION
ECHO:
echo SELECT ONE OF THE FOLLOWING TO SETUP NETWORK SETTINGS
echo [1] WIFI AUTOMATIC CONFIGURATION
echo [2] ETHERNET AUTOMATIC CONFIGURATION
echo [3] WIFI MANUAL
echo [4] ETHERNET MANUAL
echo [5] GO BACK

choice /c 12345 /N /M "Enter your choice:"

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
echo                  ^|      [1] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [2] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [3] BLANK                                                ^|
echo                  ^|                                                               ^|
echo                  ^|      [4] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [5] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [6] BLANK                                                ^|
echo                  ^|      ___________________________________________________      ^|
echo                  ^|                                                               ^|
echo                  ^|      [7] BLANK         [8] BLANK         [9] EXIT             ^|
echo                  ^|                                                               ^|
echo                  ^|===============================================================^|
echo:          
choice /C:123456789 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6,7,8,9] : "

if errorlevel  9 goto:end
if errorlevel  8 goto:TEST_UNKNOWN
if errorlevel  7 goto:TEST_UNKNOWN
if errorlevel  6 goto:TEST_UNKNOWN
if errorlevel  5 goto:TEST_UNKNOWN
if errorlevel  4 goto:TEST_UNKNOWN
if errorlevel  3 goto:TEST_UNKNOWN
if errorlevel  2 goto:TEST_UNKNOWN
if errorlevel  1 goto:TEST_UNKNOWN
cls


::-------------------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------------------

::-------------------------------------------------------------------------------------------------------

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

:SHUTDOWN_OPTIONS
title Shutdown Script
color 0A

set seconds=1

:start
cls
echo.
echo Select a number:
echo.
echo [1] Restart (Default Setting)
echo.
echo [2] Restart Reregister Applications
echo.
echo [3] Restart UEFI/BIOS
echo.
echo [4] Restart Advanced Boot Options
echo.
echo [5] Shutdown (Default Setting)
echo.
echo [6] Shutdown Reregister Applications
echo.
echo [7] Sign Out User
echo.
echo [8] GO BACK
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
color 0c
cls
echo.
echo Going back to previous menu please wait...
timeout 2 >nul
endlocal
pause & cls & goto MainMenu

:EXIT
color 0c
cls
echo This Is a work of fiction and will exit promptly
timeout 2 >nul
endlocal
pause & exit

::========================================================================================================================================

::========================================================================================================================================

:STARWARS
cls
title STARWARS
dism /online /Enable-Feature /FeatureName:TelnetClient
ECHO NOW COPY AND PASTE THIS LINE INTO TELNET ANSWER LINE:
echo:
echo towel.blinkenlights.nl
echo:
timeout 5 >nul
cls
ECHO IF YOU DON'T THEN YOU WILL NEVER SEE THIS MASTERPIECE:
ECHO TYPE: O ---- DO THIS FIRST
echo:
ECHO THEN...
ECHO:
echo towel.blinkenlights.nl
echo:
timeout 5 >nul
pause
TELNET
pause & cls & GOTO MainMenu