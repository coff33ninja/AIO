:UPDATE_APPS
Title UPDATE APPLICATIONS
ECHO:
ECHO THIS OPTION WILL START PATCH MY PC.
timeout 2 >nul
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/SOFTWARE/UPDATE_SOFTWARE/PatchMyPC.exe" -O "C:\AIO\PatchMyPC.exe" 
powershell Invoke-WebRequest "https://raw.githubusercontent.com/coff33ninja/AIO/main/SOFTWARE/UPDATE_SOFTWARE/PatchMyPC.ini" -O "C:\AIO\PatchMyPC.ini"
START C:\AIO\PatchMyPC.exe /auto switch
timeout 2 >nul
pause
del C:\AIO\PatchMyPC.exe
del C:\AIO\PatchMyPC.ini
pause & cls & goto COMPUTER_CONFIGURATION