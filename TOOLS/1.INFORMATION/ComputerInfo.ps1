#CSS codes
$header = @"
<style>

    h1 {

        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;

    }

    
    h2 {

        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;

    }

    
    
   table {
		font-size: 12px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 
	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}

    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }
    


    #CreationDate {

        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;

    }



    .StopStatus {

        color: #ff0000;
    }
    
  
    .RunningStatus {

        color: #008000;
    }




</style>
"@

#The command below will get the name of the computer
$ComputerName = "<h1>Computer name: $env:computername</h1>"

#The command below will get the Operating System information, convert the result to HTML code as table and store it to a variable
$OSinfo = Get-CimInstance -Class Win32_OperatingSystem | ConvertTo-Html -As List -Property Version, Caption, BuildNumber, Manufacturer, OSArchitecture -Fragment -PreContent "<h2>Operating System Information</h2>"

#The command below will get the Operating System HotFix information, convert the result to HTML code as table and store it to a variable
$HotFixinfo = Get-CimInstance -Class Win32_QuickFixEngineering | ConvertTo-Html -As List -Property HotFixId -Fragment -PreContent "<h2>Operating System HotFix Information</h2>"

#The command below will get the Processor information, convert the result to HTML code as table and store it to a variable
$ProcessInfo = Get-CimInstance -ClassName Win32_Processor | ConvertTo-Html -As List -Property DeviceID,Name,Caption,MaxClockSpeed,SocketDesignation,Manufacturer -Fragment -PreContent "<h2>Processor Information</h2>"

#The command below will get the RAM information, convert the result to HTML code as table and store it to a variable
$PhysicalMemoryInfo = Get-CimInstance -ClassName Win32_PhysicalMemory | ConvertTo-Html -As List -Property Manufacturer,Banklabel,Configuredclockspeed,Devicelocator,Capacity,Serialnumber -Fragment -PreContent "<h2>RAM Information</h2>"

#The command below will get the Motherboard information, convert the result to HTML code as table and store it to a variable
$MotherboardInfo = Get-CimInstance -ClassName Win32_BaseBoard | ConvertTo-Html -As List -Property Manufacturer,Model,Product,SerialNumber -Fragment -PreContent "<h2>Motherboard Information</h2>"

#The command below will get the BIOS information, convert the result to HTML code as table and store it to a variable
$BiosInfo = Get-CimInstance -ClassName Win32_BIOS | ConvertTo-Html -As List -Property SMBIOSBIOSVersion,Manufacturer,Name,SerialNumber -Fragment -PreContent "<h2>BIOS Information</h2>"

#The command below will get the GPU information, convert the result to HTML code as table and store it to a variable
$GPUInfo = Get-CimInstance -ClassName Win32_VideoController | ConvertTo-Html -As List -Property VideoProcessor,VideoModeDescription,AdapterRAM,DriverVersion,LastErrorCode -Fragment -PreContent "<h2>GPU Information</h2>"

#The command below will get the details of Disk, convert the result to HTML code as table and store it to a variable
$DiscInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ConvertTo-Html -As List -Property DeviceID,DriveType,ProviderName,VolumeName,Size,FreeSpace -Fragment -PreContent "<h2>Disk Information</h2>"

#The command below will get the BIOS information, convert the result to HTML code as table and store it to a variable
$NetworkInfo = Get-NetIPAddress | ConvertTo-Html -As List -Property IPAddress,InterfaceAlias,AddressFamily -Fragment -PreContent "<h2>Network Information</h2>"

#The command below will get first 250 services information, convert the result to HTML code as table and store it to a variable
$ServicesInfo = Get-CimInstance -ClassName Win32_Service | Select-Object -First 250  |ConvertTo-Html -Property Name,DisplayName,State -Fragment -PreContent "<h2>Services Information</h2>"
$ServicesInfo = $ServicesInfo -replace '<td>Running</td>','<td class="RunningStatus">Running</td>'
$ServicesInfo = $ServicesInfo -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'

  
#The command below will combine all the information gathered into a single HTML report
$Report = ConvertTo-HTML -Body "$ComputerName $OSinfo $HotFixinfo $ProcessInfo $PhysicalMemoryInfo $MotherboardInfo $BiosInfo $GPUInfo $DiscInfo $NetworkInfo $ServicesInfo" -Head $header -Title "Computer Information Report" -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date)</p>"

#The command below will generate the report to an HTML file
function CustomInputBox([string] $title, [string] $message, [string] $defaultText) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

    $userForm = New-Object System.Windows.Forms.Form
    $userForm.Text = "$title"
    $userForm.Size = New-Object System.Drawing.Size(290, 150)
    $userForm.StartPosition = "CenterScreen"
    $userForm.AutoSize = $False
    $userForm.MinimizeBox = $False
    $userForm.MaximizeBox = $False
    $userForm.SizeGripStyle = "Hide"
    $userForm.WindowState = "Normal"
    $userForm.FormBorderStyle = "Fixed3D"
     
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(115, 80)
    $OKButton.Size = New-Object System.Drawing.Size(75, 23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({ $value = $objTextBox.Text; $userForm.Close() })
    $userForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(195, 80)
    $CancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({ $userForm.Close() })
    $userForm.Controls.Add($CancelButton)

    $userLabel = New-Object System.Windows.Forms.Label
    $userLabel.Location = New-Object System.Drawing.Size(10, 20)
    $userLabel.Size = New-Object System.Drawing.Size(280, 20)
    $userLabel.Text = "$message"
    $userForm.Controls.Add($userLabel) 

    $objTextBox = New-Object System.Windows.Forms.TextBox
    $objTextBox.Location = New-Object System.Drawing.Size(10, 40)
    $objTextBox.Size = New-Object System.Drawing.Size(260, 20)
    $objTextBox.Text = "$defaultText"
    $userForm.Controls.Add($objTextBox) 

    $userForm.Topmost = $True
    $userForm.Opacity = 0.91
    $userForm.ShowIcon = $False

    $userForm.Add_Shown({ $userForm.Activate() })
    [void] $userForm.ShowDialog()

    $value = $objTextBox.Text 

    return $value

}


$userInput = CustomInputBox "User Name" "Please enter your name." ""
if ( $userInput -ne $null ) {
    "$Report | Out-File .\[$userInput]Basic-Computer-Information-Report.html"
}
else {
    "$Report | Out-File .\Basic-Computer-Information-Report.html"
}

