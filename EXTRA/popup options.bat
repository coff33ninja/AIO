
rem =========================================================================================================================================================
rem BASIC
rem =========================================================================================================================================================

powershell -Command "& {<PowerShell code-block goes here>}"

rem =========================================================================================================================================================
rem notification
rem =========================================================================================================================================================

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Hello world', 'This is called from a batch script.', [System.Windows.Forms.ToolTipIcon]::None)}"


rem =========================================================================================================================================================
rem Message Box
rem =========================================================================================================================================================

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Hello World', 'This is an example', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"

rem =========================================================================================================================================================
rem YesNo MessageBox
rem =========================================================================================================================================================

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Hello', 'Hey', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
if %OUT%==Yes goto Yes
if %OUT%==No goto no
:Yes
ECHO THIS WAS Yes
PAUSE
:NO
ECHO THIS WAS NO
PAUSE

rem =========================================================================================================================================================
rem Input Boxes
rem =========================================================================================================================================================

powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Enter your name:', 'Input box example')}" > %TEMP%\out.tmp
set /p OUT=<%TEMP%\out.tmp
set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have entered: %OUT%', 'Hello');}"
powershell -Command %msgBoxArgs%

rem =========================================================================================================================================================
rem Custom GUI elements
rem =========================================================================================================================================================

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; $mainForm = New-Object System.Windows.Forms.Form; $mainForm.Text = 'Main Window'; $lbl = New-Object System.Windows.Forms.Label; $lbl.Text = 'Hello World'; $mainForm.Controls.Add($lbl); $mainForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen; $mainForm.ShowDialog()}"


rem https://medium.com/swlh/how-to-enhance-your-windows-batch-files-by-adding-gui-7287d89ebad6