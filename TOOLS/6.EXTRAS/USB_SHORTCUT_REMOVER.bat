@ echo off
color 0f
mode con cols=98 lines=32
cls
echo:
title USB SHORTCUT VIRUS REMOVER
echo USB HIDDEN FILES UNHIDE INFECTED FROM VIRUS
echo:
%DRIVE_LETTER%
Set /P %DRIVE_LETTER%=Enter drive letter for usb drive:
dir/ah
pause
attrib *. -s -h /s /d
pause
cd %DRIVE_LETTER%
start .