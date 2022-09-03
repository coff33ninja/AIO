@Echo off
setlocal
:MENU
echo:
echo CHOOSE DESIRED DOWNLOAD METHOD
echo:
echo [1] WGET
echo [2] ARIA2
echo [3] POWERSHELL

choice /C:123 /N /M ">Enter Your Choice in the Keyboard [1,2,3] : "

if errorlevel  3 goto:pwrshl
if errorlevel  2 goto:ARIA2
if errorlevel  1 goto:WGET
cls
REM ===============================================================================================================
REM ===============================================================================================================
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
setx WGET C:\WGET\wget.exe /m
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
If /i "%_num%"=="I AGREE" goto WGET_METHOD

:WGET_METHOD
echo WGET SAVE LOCATION
set /p LOC=
echo WGET DOWNLOADER WEBLINK
set /p LINK=
wget -q ‐P "%LOC%" %LINK%
pause & cls & goto menu
REM ===============================================================================================================
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
setx ARIA C:\ARIA2\aria2c.exe /m
cls
echo ARIA2 SAVE LOCATION
set /p ALOC=
echo ARIA2 DOWNLOADER WEBLINK
set /p ALINK=
aria2c %ALINK% -d, --dir=%ALOC% --allow-overwrite="true" --disable-ipv6
pause & cls & goto menu

:ARIA2x32
@echo off
setlocal
CLS
title AIO - ARIA2 DOWNLOAD METHOD
md C:\ARIA2
copy .\bin\x86\aria2c.exe C:\ARIA2
cd C:\ARIA2
setx ARIA C:\ARIA2\aria2c.exe /m
cls
echo ARIA2 SAVE LOCATION
set /p ALOC=
echo ARIA2 DOWNLOADER WEBLINK
set /p ALINK=
aria2c %ALINK% -d, --dir=%ALOC% --allow-overwrite="true" --disable-ipv6
pause & cls & goto menu
REM ===============================================================================================================
:POWERSHELL
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
echo POWERSHELL SAVE LOCATION
set /p PLOC=
echo POWERSHELL DOWNLOADER WEBLINK
set /p PLINK=
powershell.exe Invoke-WebRequest "%PLINK%" -O "PLOC"
pause & cls & goto menu
REM ===============================================================================================================