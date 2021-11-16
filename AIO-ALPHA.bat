@echo OFF
setlocal
%SystemRoot%\System32\rundll32.exe shell32.dll,SHCreateLocalServerRunDll {c82192ee-6cb5-4bc0-9ef0-fb818773790a}
CLS
::========================================================================================================================================
:TERMS_AND_CONDITIONS
TITLE TERMS AND CONDITIONS
echo:
echo      ####################################################
echo      #  Read, Agree and Accept - Terms as Stated (TaS)  #
echo      ####################################################
echo:
echo           AIO v%Current_Version%
echo           Copyright (C) 2021  Coff33ninja - Darius-vr
echo:
echo               This program is distributed in the hope that it will be useful,
echo               but WITHOUT ANY WARRANTY; without even the implied warranty of
echo               MERCHANTABILITY or A PARTICULAR PURPOSE.  See the
echo               GNU General Public License for more details.
echo:
echo      User Understands:
echo           [X] This product is licened under GNU General Public v3.
echo           [X] Please note that you as end-user understands that this is a "AS IS" application.
echo           [X] As a GRAND RULE OF THUMB it is always great to read the script code first.
echo           [X] 
echo           [X] 
echo           [X] 
echo.
set /p op=Do you agree to the terms and conditions as stated? (Yes or No):
if %op%==Y goto SelfAdminTest
if %op%==Yes goto SelfAdminTest
if %op%==yes goto SelfAdminTest
if %op%==y goto SelfAdminTest
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
md C:\aio
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
::========================================================================================================================================
:COMPUTER_CONFIGURATION
::========================================================================================================================================
:UPDATER
::========================================================================================================================================
:CLEANER
::========================================================================================================================================
:AIO_PRE-SET
::========================================================================================================================================
:EXTRAS
::========================================================================================================================================

::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
::========================================================================================================================================
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

::========================================================================================================================================

::========================================================================================================================================
:EXIT
cls
TITLE Cleanup
echo CLEANING UP RESIDUE LEFT OF AIO RESIDUE
IF EXIST "c:\AIO\MAS.bat" del "c:\AIO\MAS.bat"
IF EXIST "c:\AIO\MAS.cmd" del "c:\AIO\MAS.cmd"
IF EXIST "c:\AIO\AIO.bat" del "c:\AIO\AIO.bat"
IF EXIST "c:\AIO\DEVICE_INFORMATION.bat" del "DEVICE_INFORMATION.bat"
IF EXIST "c:\AIO\NETWORK_INFORMATION.bat" del "NETWORK_INFORMATION.bat"
IF EXIST "c:\AIO\Defender_Tools.exe" del "Defender_Tools.exe"
IF EXIST "c:\AIO\NETWORK_SETUP.bat" del "NETWORK_SETUP.bat"
IF EXIST "c:\AIO\TELEMETRY.bat" del "TELEMETRY.bat"
IF EXIST "c:\AIO\WINDOWS_UPDATER.bat" del "WINDOWS_UPDATER.bat"
IF EXIST "c:\AIO\SOFTWARE_UPDATER.bat" del "SOFTWARE_UPDATER.bat"
IF EXIST "c:\AIO\DRIVER_UPDATER.bat" del "DRIVER_UPDATER.bat"
IF EXIST "c:\AIO\DEBLOATER.ps1" del "DEBLOATER.ps1"
IF EXIST "c:\AIO\DEFRAG.bat" del "DEFRAG.bat"
IF EXIST "c:\AIO\TEMP_CLEANER.bat" del "TEMP_CLEANER.bat"
IF EXIST "c:\AIO\PRE-SET.bat" del "PRE-SET.bat"
IF EXIST "c:\AIO\FOLDER_LOCKER.bat" del "FOLDER_LOCKER.bat"
IF EXIST "c:\AIO\USB_SHORTCUT_REMOVER.bat" del "USB_SHORTCUT_REMOVER.bat"
goto EXIT
:EXIT_BAR
@echo OFF
CLS
color 0c
mode con cols=55 lines=6
title Progress bar
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
:EASTER
::========================================================================================================================================
