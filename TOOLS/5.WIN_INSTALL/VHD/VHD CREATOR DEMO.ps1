$VHDType = {
Write-Host " *********************************"
Write-Host " *   Create a Virtual Hard Disk  *" 
Write-Host " *********************************" 
Write-Host " "
Write-Host " Select VHD type" 
Write-Host 
Write-Host " 1.) Create an MBR partitioned VHD" 
Write-Host " 2.) Create a GPT partitioned VHD" 
Write-Host " 3.) Quit"
Write-Host " "
Write-Host " Press 1, 2 or 3 and Enter to proceed: "  -nonewline
}

cls

Do { 
cls
Invoke-Command $VHDType
$VHDLetter = 'W'
$VHDSize = '102400'
$VHDName = Join-Path $env:USERPROFILE '\Documents\W10.vhdx'
$VHDConfig = Join-Path $env:Temp '\VHDConfig.txt'
    if (Test-Path $VHDConfig) {Remove-Item $VHDConfig}
$Select = Read-Host
Switch ($Select) {
    1 {
        $VHDName = Join-Path $env:USERPROFILE '\Documents\W10.vhdx'
            if (Test-Path $VHDName) {
            Write-Host 
            Write-Host " Found a mounted VHD" $VHDName
            Write-Host " Dismounting it, please wait a few seconds..."
            Dismount-VHD -Path $VHDName
            Start-Sleep -Seconds 10
            Remove-Item $VHDName
            cls}
                        Add-Content $VHDConfig "create vdisk file=$VHDName maximum=$VHDSize type=expandable"
                        Add-Content $VHDConfig "attach vdisk"
                        Add-Content $VHDConfig "create partition primary size=500"
                        Add-Content $VHDConfig "format quick fs=fat32 label=System"
                        Add-Content $VHDConfig "create partition primary"
                        Add-Content $VHDConfig "shrink minimum=500"
                        Add-Content $VHDConfig "format quick fs=ntfs label=Windows"
                        Add-Content $VHDConfig "assign letter=$VHDLetter"
                        Add-Content $VHDConfig "create partition primary"
                        Add-Content $VHDConfig "format quick fs=ntfs label=WinRE"
                        Add-Content $VHDConfig "set id=27"
                        Add-Content $VHDConfig "exit"
                        cmd /c diskpart /s $VHDConfig
                        Write-Host 
                        Write-Host " An MBR partitioned VHD"$VHDName "created."
                        Write-Host
                        pause
                        cls
      }
    2 {
            if (Test-Path $VHDName) {
            Write-Host 
            Write-Host " Found a mounted VHD" $VHDName
            Write-Host " Dismounting it, please wait a few seconds..."
            Dismount-VHD -Path $VHDName
            Start-Sleep -Seconds 10
            Remove-Item $VHDName
            cls}
                        Add-Content $VHDConfig "create vdisk file=$VHDName maximum=$VHDSize type=expandable"
                        Add-Content $VHDConfig "attach vdisk"
                        Add-Content $VHDConfig "convert gpt"
                        Add-Content $VHDConfig "create partition efi size=100"
                        Add-Content $VHDConfig "format quick fs=fat32 label=System"
                        Add-Content $VHDConfig "create partition msr size=128"
                        Add-Content $VHDConfig "create partition primary"
                        Add-Content $VHDConfig "shrink minimum=500"
                        Add-Content $VHDConfig "format quick fs=ntfs label=Windows"
                        Add-Content $VHDConfig "assign letter=$VHDLetter"
                        Add-Content $VHDConfig "create partition primary"
                        Add-Content $VHDConfig "format quick fs=ntfs label=WinRE"
                        Add-Content $VHDConfig "set id=de94bba4-06d1-4d40-a16a-bfd50179d6ac"
                        Add-Content $VHDConfig "gpt attributes=0x8000000000000001"
                        Add-Content $VHDConfig "exit"
                        cmd /c diskpart /s $VHDConfig
                        Write-Host 
                        Write-Host " A GPT partitioned VHD"$VHDName "created."
                        Write-Host
                        pause
                        cls
    }
}
}
 While ($Select -ne 3)