echo off
cls
rem
rem Create menu
rem
:Menu
echo.
echo #######################################
echo #    Select disk to deploy Windows.   #
echo #                                     #
echo # Select 1, if deploying Windows on a #
echo # single disk system.                 #
echo #                                     #
echo # Select 2, if deploying Windows to   #
echo # primary disk on dual disk system.   #
echo #                                     #
echo # Select 3, if deploying Windows to   #
echo # secondary disk on dual disk system. #
echo #                                     #
echo # Select 4 to quit.                   #
echo #######################################
echo.
echo 1 - Single disk
echo 2 - Dual disk primary
echo 3 - Dual disk secondary
echo 4 - Exit
echo.
rem
rem Ask user to select an option
rem
set /P M=Press 1, 2, 3, or 4 and Enter:
if %M%==1 goto Single
if %M%==2 goto Dual1
if %M%==3 goto Dual2
if %M%==4 goto Exit
:Single
rem
rem User selected option 1. 
rem  
start /wait diskpart /s X:\Scripts\SingleDisk.txt
cls
goto Deploy
:Dual1
rem
rem User selected option 2. 
rem
start /wait diskpart /s X:\Scripts\DualDisk1.txt
cls
goto Deploy
rem
:Dual2
rem
rem User selected option 3.
rem
start /wait diskpart /s X:\Scripts\DualDisk2.txt
cls
goto Deploy
rem
Rem User selected option 4. Script
rem will exit to Windows Setup
rem
:Exit
exit
rem
:Deploy
rem
rem Deploy Windows
rem
echo off
echo.
for /f %%X in ('wmic volume get DriveLetter ^, Label ^| find "W10USB"') do DISM /Apply-Image /ImageFile:%%X\Sources\install.wim /index:1 /ApplyDir:W:\
rem
rem Create boot entry
rem
W:\Windows\System32\bcdboot W:\Windows /s S:
rem
rem Create necessary folders, 
rem copy answer file to Panther folder,
rem copy recovery environment to WinRE partition
rem
md W:\Windows\Panther
md R:\Recovery\WinRE
copy X:\Scripts\unattend.xml W:\Windows\Panther\
xcopy /h W:\Windows\System32\Recovery\Winre.wim R:\Recovery\WinRE\
rem
rem Set recovery image location
rem
W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WinRE /Target W:\Windows
cls
echo.
rem
rem Restart to OOBE
rem
echo Computer will restart to OOBE in a few seconds...
W:\Windows\System32\shutdown -r -t 5
