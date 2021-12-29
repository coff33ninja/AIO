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
$ProcessInfo = Get-CimInstance -ClassName Win32_Processor | ConvertTo-Html -As List -Property DeviceID, Name, Caption, MaxClockSpeed, SocketDesignation, Manufacturer -Fragment -PreContent "<h2>Processor Information</h2>"

#The command below will get the RAM information, convert the result to HTML code as table and store it to a variable
$PhysicalMemoryInfo = Get-CimInstance -ClassName Win32_PhysicalMemory | ConvertTo-Html -As List -Property Manufacturer, Banklabel, Configuredclockspeed, Devicelocator, Capacity, Serialnumber -Fragment -PreContent "<h2>RAM Information</h2>"

#The command below will get the Motherboard information, convert the result to HTML code as table and store it to a variable
$MotherboardInfo = Get-CimInstance -ClassName Win32_BaseBoard | ConvertTo-Html -As List -Property Manufacturer, Model, Product, SerialNumber -Fragment -PreContent "<h2>Motherboard Information</h2>"

#The command below will get the BIOS information, convert the result to HTML code as table and store it to a variable
$BiosInfo = Get-CimInstance -ClassName Win32_BIOS | ConvertTo-Html -As List -Property SMBIOSBIOSVersion, Manufacturer, Name, SerialNumber -Fragment -PreContent "<h2>BIOS Information</h2>"

#The command below will get the GPU information, convert the result to HTML code as table and store it to a variable
$GPUInfo = Get-CimInstance -ClassName Win32_VideoController | ConvertTo-Html -As List -Property VideoProcessor, VideoModeDescription, AdapterRAM, DriverVersion, LastErrorCode -Fragment -PreContent "<h2>GPU Information</h2>"

#The command below will get the details of Disk, convert the result to HTML code as table and store it to a variable
$DiscInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ConvertTo-Html -As List -Property DeviceID, DriveType, ProviderName, VolumeName, Size, FreeSpace -Fragment -PreContent "<h2>Disk Information</h2>"

#The command below will get the BIOS information, convert the result to HTML code as table and store it to a variable
$NetworkInfo = Get-NetIPAddress | ConvertTo-Html -As List -Property IPAddress, InterfaceAlias, AddressFamily -Fragment -PreContent "<h2>Network Information</h2>"

#The command below will get first 250 services information, convert the result to HTML code as table and store it to a variable
$ServicesInfo = Get-CimInstance -ClassName Win32_Service | Select-Object -First 250  | ConvertTo-Html -Property Name, DisplayName, State -Fragment -PreContent "<h2>Services Information</h2>"
$ServicesInfo = $ServicesInfo -replace '<td>Running</td>', '<td class="RunningStatus">Running</td>'
$ServicesInfo = $ServicesInfo -replace '<td>Stopped</td>', '<td class="StopStatus">Stopped</td>'

  
#The command below will combine all the information gathered into a single HTML report
$Report = ConvertTo-HTML -Body "$ComputerName $OSinfo $HotFixinfo $ProcessInfo $PhysicalMemoryInfo $MotherboardInfo $BiosInfo $GPUInfo $DiscInfo $NetworkInfo $ServicesInfo" -Head $header -Title "Computer Information Report" -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date)</p>"

#The command below will generate the report to an HTML file
Function GUI_TextBox ($Input_Type) {

    ### Creating the form with the Windows forms namespace
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Enter the appropriate information' ### Text to be displayed in the title
    $form.Size = New-Object System.Drawing.Size(310, 200) ### Size of the window
    $form.StartPosition = 'CenterScreen'  ### Optional - specifies where the window should start
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow  ### Optional - prevents resize of the window
    $form.Topmost = $true  ### Optional - Opens on top of other windows

    ### Adding an OK button to the text box window
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(155, 120) ### Location of where the button will be
    $OKButton.Size = New-Object System.Drawing.Size(75, 23) ### Size of the button
    $OKButton.Text = 'OK' ### Text inside the button
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    ### Adding a Cancel button to the text box window
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(70, 120) ### Location of where the button will be
    $CancelButton.Size = New-Object System.Drawing.Size(75, 23) ### Size of the button
    $CancelButton.Text = 'Cancel' ### Text inside the button
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    ### Putting a label above the text box
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 10) ### Location of where the label will be
    $label.AutoSize = $True
    $Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold) ### Formatting text for the label
    $label.Font = $Font
    $label.Text = $Input_Type ### Text of label, defined by the parameter that was used when the function is called
    $label.ForeColor = 'Red' ### Color of the label text
    $form.Controls.Add($label)

    ### Inserting the text box that will accept input
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, 40) ### Location of the text box
    $textBox.Size = New-Object System.Drawing.Size(275, 50) ### Size of the text box
    $textBox.Multiline = $false ### Allows multiple lines of data
    $textbox.AcceptsReturn = $true ### By hitting enter it creates a new line
    $textBox.ScrollBars = "Vertical" ### Allows for a vertical scroll bar if the list of text is too big for the window
    $form.Controls.Add($textBox)

    $form.Add_Shown({ $textBox.Select() }) ### Activates the form and sets the focus on it
    $result = $form.ShowDialog() ### Displays the form 

    ### If the OK button is selected do the following
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        ### Removing all the spaces and extra lines
        $x = $textBox.Lines | Where-Object { $_ } | ForEach-Object { $_.Trim() }
        ### Putting the array together
        $array = @()
        ### Putting each entry into array as individual objects
        $array = $x -split "`r`n"
        ### Sending back the results while taking out empty objects
        Return $array | Where-Object { $_ -ne '' }
    }

    ### If the cancel button is selected do the following
    if ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
        $Report | Out-File .\Basic-Computer-Information-Report.html
        $Report | Out-File C:\Windows\Temp\Basic-Computer-Information-Report.html
        Write-Host "DEFAULT NAME WILL BE USED INSTEAD" -BackgroundColor Red -ForegroundColor White
        Write-Host "Press any key to exit..."
        $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Exit
    }

}
###############################################################################




$USERNAME = GUI_TextBox "ENTER YOUR NAME HERE:" ### Calls the text box function with a parameter and puts returned input in variable
$USER_Count = $USERNAME | Measure-Object | ForEach-Object { $_.Count } ### Measures how many objects were inputted

If ($USER_Count -eq 0) {
    ### If the count returns 0 it will throw and error
    $Report | Out-File .\Basic-Computer-Information-Report.html
    $Report | Out-File C:\Windows\Temp\Basic-Computer-Information-Report.html
    Return
}
Else {
    ### If there was actual data returned in the input, the script will continue
    $Report | Out-File .\$USERNAME-Basic-Computer-Information-Report.html
    $Report | Out-File C:\Windows\Temp\Basic-Computer-Information-Report.html
    ### Here is where you would put your specific code to take action
}