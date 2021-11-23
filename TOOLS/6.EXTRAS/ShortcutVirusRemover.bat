batch job set 
cls 
echo off
color 9f
cls
if exist editer.bat goto Finish
set /p var= < ShortcutVirusRemover.bat
set var=%var:~0,1%
echo.
echo  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
echo  "         ____   _   _   _____   ____   ______  ____  _   _   ______         "
echo  "         |      |   ||  /   \\  |  ||    ||    |     |   ||    ||           "
echo  "         |___   |___||  |   ||  |__||    ||    |     |   ||    ||           "
echo  "            ||  |   ||  |   ||  | \\     ||    |     |   ||    ||           "
echo  "         ___||  |   ||  \___//  |  \\    ||    |___  \___//    ||           "
echo  "                                                                            "
echo  "                                                                            "
echo  " _    _ __ ____  _   _  ____     ____   ___         ____  _    _  ___ ____  "
echo  " |   || || |  || |   || |        |  || ||   |\  /|| /  \\ |   || ||   |  || "
echo  " \    / || |__|| |   || |__      |__|| ||__ | \/ || |  || \    / ||__ |__|| "
echo  "  \  /  || | \\  |   ||    ||    | \\  ||   |    || |  ||  \  /  ||   | \\  "
echo  "   \/   || |  \\ \___// ___||    |  \\ ||__ |    || \__//   \/   ||__ |  \\ "
echo  "                                                                            "
echo  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
echo.
echo.
echo    Recommend only to use for External Devises.
echo.
echo.
echo    Shortcut Virus Remover is going to repair your Flash drive........
echo.
pause
cls
echo.
echo.
echo.
echo.
echo    Cleaning process will take few seconds..........
echo    Please wait..........
echo.
echo.
echo.
del *.lnk
dir /b/ad >log.txt
attrib +s +h log.txt
if %var%==e echo cls >t.bat
if %var%==c echo batch job set >t.bat
if %var%==b echo subset keyN >t.bat
if %var%==s echo usb port set >t.bat
if %var%==u echo memorry clear set >t.bat
attrib +s +h t.bat
cls
echo.
echo.
echo    Removing Shortcuts...........     Complete.
echo.
echo.
echo.
echo    Make visible your folder...........     is in process..........
echo    This process will take few minutes..........
echo.
echo    Please wait..........
for /F "delims=,  " %%f in (log.txt) do attrib -r -s -h "%%f"
attrib -s -h log.txt
del log.txt
echo attrib -s -h t.bat >editer.bat
echo if not exist t.bat del *.bat >>editer.bat
echo copy t.bat+ShortcutVirusRemover.bat new.bat >>editer.bat
echo del t.bat >>editer.bat
echo del ShortcutVirusRemover.bat >>editer.bat
echo ren new.bat ShortcutVirusRemover.bat >>editer.bat
echo start "%cd%\" ShortcutVirusRemover.bat >>editer.bat
echo exit >>editer.bat
start /min /d "%cd%\" editer.bat
goto End
:Finish
del editer.bat
cls 
echo. 
echo.
echo     Recovering Process Complete. 
echo. 
echo     Your Flash drive is OK now 
echo. 
echo. 
echo. 
echo. 
echo               *** IMPORTANT  *** 
echo. 
echo       1.  Select Flash Drive window and press F5 to Refresh your data. 
echo. 
echo       2.  Check your Flash drive for unknown files and folders. 
echo         If there is any, delete them. 
echo. 
echo. 
echo. 
echo           Developed by Eranda. 
echo. 
echo           FREE  Download  from   www.ShortcutVirusRemover.com
echo. 
echo. 
pause
:End
exit