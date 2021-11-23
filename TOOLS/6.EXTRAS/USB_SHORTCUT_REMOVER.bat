@ECHO OFF

title Shortcut Virus Remover
echo This program can remove shortcut viruses from any infected drive. Wanna give it a try?
echo Just enter the drive letter of the infected drive:

:START
set/p "d="

if EXIST %d%:\ goto DO
if NOT EXIST %d%:\ goto DONOT

:DO
echo If you have more files, it may take more time. So, please, be patient...
attrib -h -r -a -s /s /d %d%:\*.*
del /a /q /s %d%:\*.lnk
echo ___________________________________________________________________________________________
echo Done!!!!
ECHO Shortcut viruses have successfully been removed from drive %d%
ECHO All files have successfully been recovered from drive %d%
echo ___________________________________________________________________________________________
ECHO Press Enter key to close the window...
set/p "k="
goto END

:DONOT
echo Not such drive letter found
echo Please check your drive letter and try again:
goto START
:END
cd %d%
start . %d%