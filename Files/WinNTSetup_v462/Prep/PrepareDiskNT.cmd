@ECHO OFF
CLS
CD %~dp0
IF EXIST GPT.ini DEL GPT.ini
IF EXIST MBR.ini DEL MBR.ini
IF EXIST tempgpt.ini DEL tempgpt.ini
IF EXIST tempmbr.ini DEL tempmbr.ini
TITLE Prepare Disk for WinNTSetup4
:PRIVILEGECHECK
NET SESSION >nul 2>&1
IF %errorlevel% == 0 (
GOTO SELECTTYPE
) else (
GOTO GETPRIVILEGE
)
:NOPRIVILEGE
ECHO        Prepare Hard Disks for WinNTSetup4 GPT or MBR
ECHO -----------------------------------------------------------
ECHO           Warning, Elevated Privilege is Required 
ECHO.                                       
ECHO                 RE-OPEN AS AN ADMINISTRATOR        
ECHO                  THE PROGRAM WILL NOW EXIT 
ECHO.
ECHO -----------------------------------------------------------
ECHO.
PAUSE
EXIT
:GETPRIVILEGE
SET "params=%*"
SETLOCAL EnableDelayedExpansion
CD /d "%~dp0" && ( IF EXIST "%temp%\getadmin.vbs" DEL "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>NUL 2>NUL || (  ECHO Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k CD ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && EXIT /B )
GOTO NOPRIVILEGE
:SELECTTYPE
ECHO Prepare Hard Disk for WinNTSetup4 GPT or MBR
ECHO --------------------------------------------
ECHO.
CHOICE /C MG /M "Are you setting up for MBR or GPT "
IF %ERRORLEVEL% == 1 GOTO INITMBR
IF %ERRORLEVEL% == 2 GOTO INITGPT
ECHO.
ECHO Invalid selection! Please choose a valid selection.
ECHO.
PAUSE
GOTO SELECTTYPE
EXIT
:INITMBR
CLS
ECHO Prepare Hard Disk for WinNTSetup4 (MBR)
ECHO --------------------------------------------
ECHO.
ECHO list disk >> list.txt
diskpart /s list.txt
DEL list.txt>nul
ECHO.
SET /p disk="Which disk number would you like to prepare? (e.g. 0): "
IF [%DISK%] == [] GOTO INITMBR
ECHO.
ECHO --WARNING-- This will FORMAT the selected disk and ERASE ALL DATA
ECHO.
ECHO You selected disk ---^> %disk%
ECHO.
CHOICE /C YN /M "Is this correct "
IF %ERRORLEVEL% == 1 GOTO INITMBR2
CLS
ECHO Preperation Aborted, No changes have been made...
ECHO.
PAUSE
EXIT
:INITMBR2
SET "a="
FOR %%a IN (Z Y X W V U T S R Q P O N M) DO (
IF NOT EXIST "%%a:" SET BOOTDRV=%%a
)
ECHO sel dis %disk% >> initmbr.txt
ECHO clean >>initmbr.txt
ECHO convert mbr >> initmbr.txt
ECHO cre par pri >> initmbr.txt
ECHO for quick fs=ntfs label="Windows" >> initmbr.txt
ECHO assign letter %BOOTDRV% >> initmbr.txt
ECHO active >> initmbr.txt
ECHO exit >> initmbr.txt
:RUNMBR
CLS
diskpart /s initmbr.txt
DEL initmbr.txt >nul
ECHO.
ECHO This drive is now prepared for WinNTSetup4 - MBR\Legacy
ECHO.
ECHO The following drive letters have been assigned, and
ECHO will be automatically loaded into WinNTSetup4
ECHO.
ECHO Boot Drive----------: %BOOTDRV%
ECHO Installation Drive--: %BOOTDRV%
ECHO.
PAUSE
ECHO.
ECHO Please wait while WinNTSetup4 loads...
CD %~dp0
powershell -Command "(gc template.ini) -replace 'BootDest=changeme', 'BootDest=%BOOTDRV%:' | Out-File tempmbr.ini"
powershell -Command "(gc tempmbr.ini) -replace 'TempDest=changeme', 'TempDest=%BOOTDRV%:' | Out-File MBR.ini"
CD ..
START winntsetup_x64.exe /cfg:prep\MBR.ini
EXIT
:INITGPT
CLS
ECHO Prepare Hard Disk for WinNTSetup3 (GPT)
ECHO --------------------------------------------
ECHO.
ECHO list disk >> list.txt
diskpart /s list.txt
DEL list.txt>nul
ECHO.
SET /p disk="Which disk number would you like to prepare? (e.g. 0): "
IF [%disk%] == [] GOTO INITGPT
ECHO.
ECHO --WARNING-- This will FORMAT the selected disk and ERASE ALL DATA
ECHO.
ECHO You selected disk ---^> %disk%
ECHO.
CHOICE /C YN /M "Is this correct "
IF %ERRORLEVEL% == 1 GOTO INITGPT2
CLS
ECHO Preperation Aborted, No changes have been made...
ECHO.
PAUSE
EXIT
:INITGPT2
SET "b="
FOR %%b IN (Q P O N M L K J I) DO (
IF NOT EXIST "%%b:" SET BOOTDRV=%%b
)
SET "c="
FOR %%c IN (Z Y X W V U T S R) DO (
IF NOT EXIST "%%c:" SET DATADRV=%%c
)
ECHO select disk %disk% >> initgpt.txt
ECHO clean >> initgpt.txt
ECHO convert gpt >> initgpt.txt
ECHO cre par efi size=100 >> initgpt.txt
ECHO for quick fs=fat32 label="System" >> initgpt.txt
ECHO assign letter %BOOTDRV% >> initgpt.txt
ECHO cre par msr size=16 >> initgpt.txt
ECHO cre par pri >> initgpt.txt
ECHO shrink minimum=450 >> initgpt.txt
ECHO for quick fs=ntfs label="Windows" >> initgpt.txt
ECHO assign letter %DATADRV% >> initgpt.txt
ECHO cre par pri >> initgpt.txt
ECHO for quick fs=ntfs label="WinRE" >> initgpt.txt
ECHO set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac" >> initgpt.txt
:RUNGPT
CLS
diskpart /s initgpt.txt
DEL initgpt.txt >nul
ECHO.
ECHO This drive is now prepared for WinNTSetup4 - GPT\UEFI
ECHO.
ECHO The following drive letters have been assigned, and
ECHO will be automatically loaded into WinNTSetup4
ECHO.
ECHO Boot Drive----------: %BOOTDRV%
ECHO Installation Drive--: %DATADRV% 
ECHO.
PAUSE
ECHO.
ECHO Please wait while WinNTSetup4 loads...
CD %~dp0
powershell -Command "(gc template.ini) -replace 'BootDest=changeme', 'BootDest=%BOOTDRV%:' | Out-File tempgpt.ini"
powershell -Command "(gc tempgpt.ini) -replace 'TempDest=changeme', 'TempDest=%DATADRV%:' | Out-File GPT.ini"
CD ..
START winntsetup_x64.exe /cfg:prep\GPT.ini
EXIT