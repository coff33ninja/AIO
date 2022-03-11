@ECHO OFF
REM The following is the command to call this batch file from Task Scheduler for the "lock screen" or "login" event.
rem %COMSPEC% /c IF EXIST \\domain.local\netlogon\* ( start "Backup Agent" /min "\\domain.local\netlogon\restic-backup.bat" ) ^& exit
ECHO Setting environment variables, please wait...
SET RESTIC_REPOSITORY=rest:http://san:8000/repo
SET RESTIC_PASSWORD=ABCDEFGHIJKLMNOPQRSTUVWXYZ

REM Skip backup for administrators
IF /I %USERNAME% == administrator exit

REM Delete stale script lock file in case of prior interruption
del /f /s /q /a \\mss.ramlaw.local\ram-backup\.restic\logs\~%USERNAME%-%COMPUTERNAME%.LOCK

REM Determine if 32-bit or 64-bit OS
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set RESTIC_BIN=restic_x86.exe || set RESTIC_BIN=restic.exe

:START

REM Count .lock files created by current backups
FOR /f %%i in ('dir /b \\san\data\.restic\logs\*.lock ^| find /v /c "::"') do set LOCKS=%%i

CLS
ECHO Restic Backup Agent by Akrabu
ECHO.

REM Check for too many concurrent backups
IF %LOCKS% GEQ 6 (
ECHO Too many concurrent backups; waiting...

REM Generate random number from 1 to 300 and wait that many seconds
SET /A _RAND=%RANDOM% %% 300 + 1
TIMEOUT %_RAND%
GOTO START
)

REM Placeholder for a mandatory pause 
rem PING localhost -n 10 >NUL

REM Create lock file
ECHO. > \\san\data\.restic\logs\~%USERNAME%-%COMPUTERNAME%.LOCK

REM Write log header
ECHO. >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
ECHO ------------------------------------------------------- >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
ECHO. >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
ECHO STARTED: %DATE% %TIME% >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG

REM Check if repository is locked and write to log
IF NOT EXIST \\san\data\.restic\unlocked (
 ECHO. >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
 ECHO REPOSITORY LOCKED OR UNAVAILABLE >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
)

REM Check for low bandwidth users
IF /I %USERNAME% == slowusername GOTO SLOW

REM Run backup, write output to log
ECHO Backing up user profile, please wait...
IF EXIST \\san\data\.restic\unlocked ( 
 \\san\data\.restic\%RESTIC_BIN% backup --cleanup-cache %USERPROFILE% %PROGRAMDATA% --tag USER_PROFILE --exclude-file=\\san\data\.restic\excludes.txt >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
 GOTO DONE
)

:SLOW

REM Run SLOW backup, write output to log
ECHO Backing up user profile, please wait...
IF EXIST \\san\data\.restic\unlocked ( 
 ECHO SLOW RUN: >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
 \\san\data\.restic\%RESTIC_BIN% backup --cleanup-cache %USERPROFILE% %PROGRAMDATA% --tag USER_PROFILE --exclude-file=\\san\data\.restic\excludes.txt --limit-upload=1024 >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
 ECHO. >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
 GOTO DONE
)

:DONE

REM Write log footer
ECHO. >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG
ECHO STOPPED: %DATE% %TIME% >>\\san\data\.restic\logs\%USERNAME%-%COMPUTERNAME%.LOG

REM Delete lock file
del /f /s /q /a \\san\data\.restic\logs\~%USERNAME%-%COMPUTERNAME%.LOCK

:END

REM Done!
CLS
ECHO Restic Backup Agent by Akrabu
ECHO.
ECHO Backup complete!
ECHO.
ECHO ---

REM Loop commands
rem TIMEOUT 3600
rem GOTO START

EXIT