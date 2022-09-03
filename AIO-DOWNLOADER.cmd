@echo off
setlocal
CLS
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

:Variables
cd /d %~dp0
md bin
Set "Path=%Path%;%CD%;%CD%\bin;"
set maindir=%CD%
set format=Yes
set formatcolor=2F
cls

::========================================================================================================================================
::========================================================================================================================================

:DownloadMainMenu
@echo off
setlocal
CLS
title  AIO TOOLBOX ARIA VERSION
mode con cols=98 lines=30
echo:
echo                       Press the corresponding number to go to desired section:
echo:
echo                [7;31m                                                                   [0m
echo                [7;31m  [0m                                                               [7;31m  [0m                  
echo                [7;31m  [0m                  [105mAIO DOWNLOADER MAIN MENU[0m                     [7;31m  [0m 
echo                [7;31m  [0m                                                               [7;31m  [0m
echo                [7;31m  [0m       [41m                                                   [0m     [7;31m  [0m
echo                [7;31m  [0m                                                               [7;31m  [0m
echo                [7;31m  [0m       [92m[1][0m  WGET METHOD                                        [7;31m  [0m
echo                [7;31m  [0m                                                               [7;31m  [0m
echo                [7;31m  [0m       [92m[2][0m  POWERSHELL METHOD                                  [7;31m  [0m
echo                [7;31m  [0m                                                               [7;31m  [0m
echo                [7;31m  [0m       [92m[3][0m  ARIA2 METHOD                                       [7;31m  [0m
echo                [7;31m  [0m                                                               [7;31m  [0m
echo                [7;31m  [0m       [92m[4][0m  OFFLINE - LIMITED TOOLS                            [7;31m  [0m
echo                [7;31m  [0m                                                               [7;31m  [0m
echo                [7;31m  [0m       [41m                                                   [0m     [7;31m  [0m
echo                [7;31m  [0m                                              [41m [0m                [7;31m  [0m
echo                [7;31m  [0m       [96m[5][0m SHUTDOWN OPTIONS                   [41m [0m    [93m[6][0m EXIT    [7;31m  [0m
echo                [7;31m  [0m                                              [41m [0m                [7;31m  [0m
echo                [7;31m                                                                   [0m                  
echo:          
choice /C:123456 /N /M ">                   Enter Your Choice in the Keyboard [1,2,3,4,5,6] : "

if errorlevel  6 goto:EXIT
if errorlevel  5 goto:SHUTDOWN_OPTIONS
if errorlevel  4 goto:OFFLINE
if errorlevel  3 goto:ARIA2
if errorlevel  2 goto:pwrshl
if errorlevel  1 goto:WGET
cls

:WGET
@echo off
setlocal
CLS
md C:\WGET
echo.This requires windows 10 version 1703 or higher.
if defined ProgramFiles(x86) (goto wget64) else (goto wget32)
:wget32
curl -O -s https://eternallybored.org/misc/wget/1.21.3/32/wget.exe
cd C:\WGET
move .\wget.exe C:\WGET\wget.exe
pause & cls & goto winvercheck0
:wget64
curl -O -s https://eternallybored.org/misc/wget/1.21.3/64/wget.exe
cd C:\WGET
move .\wget.exe C:\WGET\wget.exe
pause & cls & goto winvercheck0
:winvercheck0
for /f "tokens=2 delims=," %%i in ('wmic os get caption^,version /format:csv') do set os=%%i
set os=%os:~0,20%
if "%os%" == "Microsoft Windows 8" (goto AIO_WGET) else (goto winvercheck1)
:winvercheck1
if "%os%" == "Microsoft Windows 10" (goto AIO_WGET) else (goto winvercheck2)
:winvercheck2
if "%os%" == "Microsoft Windows 11" (goto AIO_WGET) else (goto backupcheck)
:backupcheck
for /f "tokens=4-5 delims=. " %%i in ('ver') do set os2=%%i.%%j
if "%os2%" == "10.0" goto AIO_WGET
goto winvererror

:winvererror
mode con:cols=64 lines=18
title AIO TOOLSET [UNSUPPORTED]
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                  [91m%os%[0m                 IIII
echo.IIII                   Is Not Supported.                   IIII
echo.IIII                                                       IIII
echo.IIII            PLEASE UPDATE TO WINDOWS 10/11             IIII
echo.IIII                                                       IIII
echo.IIII          [91mINSIDER BUILDS MAY HAVE THIS ERROR[0m           IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
Set /P _num=To Bypass This Warning Type "I AGREE": || Set _num=NothingChosen
If "%_num%"=="NothingChosen" exit
If /i "%_num%"=="I AGREE" goto AIO_WGET
:AIO_WGET
@echo off
setlocal
CLS
echo.
echo NOW DOWNLOADING AIO WITH WGET
wget ‐P "C:\AIO" https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO.cmd
wget ‐P "C:\AIO" https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO-LOGO.ico
move .\AIO.cmd C:\AIO
move .\AIO-LOGO.ico C:\AIO
call C:\AIO\AIO.cmd
pause && cls && goto DownloadMainMenu


:pwrshl
@echo off
setlocal
CLS
if exist "%SYSTEMROOT%\system32\WindowsPowerShell\v1.0\powershell.exe" (goto pwrshl_dwn) else (goto pwrshlerr)
:pwrshlerr
mode con:cols=64 lines=18
title AIO TOOLSET [ERROR]
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.IIII                                                       IIII
echo.IIII                 THIS PROGRAM REQUIRES                 IIII
echo.IIII              POWERSHELL TO BE INSTALLED.              IIII
echo.IIII                                                       IIII
echo.IIII         PLEASE INSTALL POWERSHELL ON YOUR OS          IIII
echo.IIII                 AND TRY AGAIN. THANKS.                IIII
echo.IIII                                                       IIII
echo.IIII                                                       IIII
echo.II-----------------------------------------------------------II
echo.II-----------------------------------------------------------II
echo.If you believe it IS installed and want to bypass this warning,
Set /P _num=type "OK": || Set _num=NothingChosen
If "%_num%"=="NothingChosen" exit
If /i "%_num%"=="ok" goto DownloadMainMenu
:pwrshl_dwn
echo.
echo NOW DOWNLOADING AIO USING POWERSHELL
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO.cmd" -O "C:\AIO\AIO.cmd"
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO-LOGO.ico" -O "C:\AIO-LOGO.ico"
call C:\AIO\AIO.cmd
pause && cls && goto DownloadMainMenu

:ARIA2
@echo off
setlocal
CLS
md C:\ARIA2
if defined ProgramFiles(x86) (goto ARIA2x64) else (goto ARIA2x32)
:ARIA2x64
@echo off
setlocal
CLS
title AIO - ARIA2 DOWNLOAD METHOD
md C:\ARIA2
copy .\bin\x64\aria2c.exe C:\ARIA2
cd C:\ARIA2
setx ARIA C:\AIO\aria2c.exe /m
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO_ARIA_VERSION.cmd -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO-LOGO.ico -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
call C:\AIO\AIO_ARIA_VERSION.cmd
:ARIA2x32
@echo off
setlocal
CLS
title AIO - ARIA2 DOWNLOAD METHOD
md C:\ARIA2
copy .\bin\x86\aria2c.exe C:\ARIA2
cd C:\ARIA2
setx ARIA C:\ARIA2\aria2c.exe /m
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO_ARIA_VERSION.cmd -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
aria2c https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO-LOGO.ico -d, --dir=C:\AIO --allow-overwrite="true" --disable-ipv6
call C:\AIO\AIO_ARIA_VERSION.cmd

:OFFLINE
echo.
echo RESERVED FOR A FEW OFFLINE CHECKS AND QUICK FIXES
pause && cls && goto DownloadMainMenu









































:EXIT
echo.
echo Thank you for using AIO TOOLBOX
pause && exit



































































































































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

