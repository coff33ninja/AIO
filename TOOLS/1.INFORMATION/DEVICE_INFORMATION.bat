@echo off
if %os%==Windows_NT goto WINNT
goto NOCON

:WINNT
echo .Using a Windows NT based system
echo ..%computername%

REM set variables
set system=
set manufacturer=
set model=
set serialnumber=
set osname=
set sp=
setlocal ENABLEDELAYEDEXPANSION
set "volume=C:"
set totalMem=
set availableMem=
set usedMem=
set IPv4=
set Domain=

echo Getting data [Computer: %computername%]...
echo Please Wait....

REM Get Computer Name
FOR /F "tokens=2 delims='='" %%A in ('wmic OS Get csname /value') do SET system=%%A

REM Get Computer Manufacturer
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Manufacturer /value') do SET manufacturer=%%A

REM Get Computer Model
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Model /value') do SET model=%%A

REM Get Computer Serial Number
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A

REM Get Computer OS
FOR /F "tokens=2 delims='='" %%A in ('wmic os get Name /value') do SET osname=%%A
FOR /F "tokens=1 delims='|'" %%A in ("%osname%") do SET osname=%%A

REM Get Computer OS SP
FOR /F "tokens=2 delims='='" %%A in ('wmic os get ServicePackMajorVersion /value') do SET sp=%%A

REM Get Memory
FOR /F "tokens=4" %%a in ('systeminfo ^| findstr Physical') do if defined totalMem (set availableMem=%%a) else (set totalMem=%%a)
set totalMem=%totalMem:,=%
set availableMem=%availableMem:,=%
set /a usedMem=totalMem-availableMem

FOR /f "tokens=1*delims=:" %%i IN ('fsutil volume diskfree %volume%') DO (
    SET "diskfree=!disktotal!"
    SET "disktotal=!diskavail!"
    SET "diskavail=%%j"
)
FOR /f "tokens=1,2" %%i IN ("%disktotal% %diskavail%") DO SET "disktotal=%%i"& SET "diskavail=%%j"


echo done!

echo --------------------------------------------
echo System Name: %system%
echo Manufacturer: %manufacturer%
echo Model: %model%
echo Serial Number: %serialnumber%
echo Operating System: %osname%
echo C:\ Total: %disktotal:~0,-9% GB
echo C:\ Avail: %diskavail:~0,-9% GB
echo Total Memory: %totalMem%
echo Used  Memory: %usedMem%
echo Computer Processor: %processor_architecture%
echo Service Pack: %sp%
echo --------------------------------------------

REM Generate file
SET file="C:/computername%.txt"
echo -------------------------------------------- >> %file%
echo Details For: %system% >> %file%
echo Manufacturer: %manufacturer% >> %file%
echo Model: %model% >> %file%
echo Serial Number: %serialnumber% >> %file%
echo Operating System: %osname% >> %file%
echo C:\ Total: %disktotal:~0,-9% GB
echo C:\ Avail: %diskavail:~0,-9% GB
echo Total Memory: %totalMem% >> %file%
echo Used  Memory: %usedMem% >> %file%
echo Computer Processor: %processor_architecture% >> %file%
echo Service Pack: %sp% >> %file%
echo -------------------------------------------- >> %file%

echo %system%, %model%, %serialnumber%, %osname%, >> hardware-audit.csv
REM systeminfo | findstr /c:"Host Name" /c:"OS Name" /c:"OS Version" /c:"System Manufacturer" /c:"System Model" /c:"System type" /c:"Total Physical Memory" /c:"Domain"

REM request user to push any key to continue
pause

goto END

:NOCON
echo Error...Invalid Operating System...
echo Error...No actions were made...
goto END

:END
PAUSE