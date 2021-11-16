
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
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/SOFTWARE/ACTIVATION_AND_DEFENDER_TOOLS/disable-windows-defender.ps1" -O "c:\aio\disable-windows-defender.ps1"
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
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/SOFTWARE/ACTIVATION_AND_DEFENDER_TOOLS/Defender_Tools.exe" -O "c:\aio\Defender_Tools.exe"
start c:\aio\Defender_Tools.exe 
pause
popd
timeout 2 >nul
del "c:\aio\Defender_Tools.exe"
endlocal
pause & cls & goto COMPUTER_CONFIGURATION