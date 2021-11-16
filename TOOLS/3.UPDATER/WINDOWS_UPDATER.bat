:WUPDATE
cls
echo This will start a Windows Manual Updater
timeout 2 >nul
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/SOFTWARE/UPDATE_SOFTWARE/WUpdater.exe" -O "C:\AIO\WUpdater.exe"
start c:\aio\WUpdater.exe
timeout 2 >nul
pause
del C:\AIO\WUpdater.exe
pause & cls & goto COMPUTER_CONFIGURATION