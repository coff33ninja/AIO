if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

#Stops Windows Update and disables it on Startup
Stop-Service wuauserv
Set-Service wuauserv -StartupType Disabled

#Prompt user to select # of days to pause updates for
$NumberofDays = Read-Host -Prompt "Enter Number of days "
$newdate = (Get-Date).AddDays($NumberofDays)

#Create a New Scheduled Task to run at date specified above
New-ScheduledTaskTrigger -At $newdate -Once

#Sets new task action to open powershell and start the update service
$action = New-ScheduledTaskAction -Execute "Powershell.exe" `
-Argument '-NoProfile -WindowStyle Hidden -command {Start-Service wuauserv}' 

#Sets trigger action to happen once at the new date specified
$trigger = New-ScheduledTaskTrigger -at $newdate -Once

#Creates the New Scheduled Task
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "PauseWinUpdates" -Description "Powershell script to pause Windows Updates until a certain date that is specified by the user"