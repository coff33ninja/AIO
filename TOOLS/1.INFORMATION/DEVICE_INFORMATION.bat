
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