###### Location selector section ######
Write-Host -ForegroundColor green "Please select the specified folder where the backups must be stored to."
Write-Host -ForegroundColor green "Press any key to continue..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Clear-Host
Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$null = $browser.ShowDialog()
$path = $browser.SelectedPath


$destination = "$path"
$folder = "Desktop",
"Downloads",
"Favorites",
"Documents",
"Music",
"Pictures",
"Videos",
"AppData\Local\Mozilla",
"AppData\Local\Google",
"AppData\Roaming\Mozilla"
##"$Input = Read-Host -Prompt" "If you want to add another location to backup please select here" (need to ad yes or no with popup screen to select path containin data)
###############################################################################################################

$username = Get-Content env:username
$userprofile = Get-Content env:userprofile
$appData = Get-Content env:localAPPDATA


###### Restore data section ######
if ([IO.Directory]::Exists($destination + "\" + $username + "\")) { 

	$caption = "Choose Action";
	$message = "A backup folder for $username already exists, would you like to restore the data to the local machine?";
	$Yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes";
	$No = new-Object System.Management.Automation.Host.ChoiceDescription "&No", "No";
	$choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No);
	$answer = $host.ui.PromptForChoice($caption, $message, $choices, 0)

	if ($answer -eq 0) {
		
		write-host -ForegroundColor green "Restoring data to local machine for $username"
		foreach ($f in $folder) {	
			$currentLocalFolder = $userprofile + "\" + $f
			$currentRemoteFolder = $destination + "\" + $username + "\" + $f
			write-host -ForegroundColor cyan "  $f..."
			Copy-Item -ErrorAction silentlyContinue -recurse $currentRemoteFolder $userprofile
			
			if ($f -eq "AppData\Local\Mozilla") { rename-item $currentLocalFolder "$currentLocalFolder.old" }
			if ($f -eq "AppData\Roaming\Mozilla") { rename-item $currentLocalFolder "$currentLocalFolder.old" }
			if ($f -eq "AppData\Local\Google") { rename-item $currentLocalFolder "$currentLocalFolder.old" }
		
		}
		rename-item "$destination\$username" "$destination\$username.restored"
		write-host -ForegroundColor green "Restore Complete!"
	}
	
	else {
		write-host -ForegroundColor yellow "Aborting process"
		exit
	}
	
	
}

###### Backup Data section ########
else { 
		
	Write-Host -ForegroundColor green "Outlook is about to close, save any unsaved emails then press any key to continue ..."

	$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	
	Get-Process | Where-Object { $_.Name -Eq "OUTLOOK" } | Stop-Process
	Clear-Host
	write-host -ForegroundColor green "Backing up data from local machine for $username"
	
	foreach ($f in $folder) {	
		$currentLocalFolder = $userprofile + "\" + $f
		$currentRemoteFolder = $destination + "\" + $username + "\" + $f
		$currentFolderSize = (Get-ChildItem -ErrorAction silentlyContinue $currentLocalFolder -Recurse -Force | Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
		$currentFolderSizeRounded = [System.Math]::Round($currentFolderSize)
		write-host -ForegroundColor cyan "  $f... ($currentFolderSizeRounded MB)"
		Copy-Item -ErrorAction silentlyContinue -recurse $currentLocalFolder $currentRemoteFolder
	}
	
	
	
	$oldStylePST = [IO.Directory]::GetFiles($appData + "\Microsoft\Outlook", "*.pst") 
	foreach ($pst in $oldStylePST) { 
		if ((test-path -path ($destination + "\" + $username + "\Documents\Outlook Files\oldstyle")) -eq 0) { new-item -type directory -path ($destination + "\" + $username + "\Documents\Outlook Files\oldstyle") | out-null }
		write-host -ForegroundColor yellow "  $pst..."
		Copy-Item $pst ($destination + "\" + $username + "\Documents\Outlook Files\oldstyle")
	}    
	
	write-host -ForegroundColor green "Backup complete!"
}	
