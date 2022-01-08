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

md C:\AIO
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO.cmd" -O "C:\AIO\AIO.cmd"
powershell.exe Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/AIO-LOGO.ico" -O "C:\AIO-LOGO.ico"

set WrkDir=C:\AIO
set LinkName=AIO.lnk
set filname=AIO.cmd
set ThePath=C:\AIO\AIO.cmd
set comment=1234-5678
set icon=C:\AIO-LOGO.ico

mshta VBScript:Execute("Set Shell=CreateObject(""WScript.Shell""):Set Link=Shell.CreateShortcut(""!LinkName!""):Link.TargetPath=""!ThePath!"":Link.WorkingDirectory=""!WrkDir!"":Link.Description=""!comment!"":Link.IconLocation=""!icon!"":Link.Save:close"^)

if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AIO" (
  del /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AIO"
) else (
  mkdir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AIO"
)

copy /y AIO.lnk "%USERPROFILE%\Desktop\" >nul 2>nul
move /y *.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AIO\" >nul 2>nul

call C:\AIO\AIO.cmd

exit

