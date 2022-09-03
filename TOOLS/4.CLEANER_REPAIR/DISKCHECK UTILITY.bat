@Echo off
echo DISK CHECK CMD WITH INPUT
set /p input=
chkdsk %input%: /r /i /f
pause