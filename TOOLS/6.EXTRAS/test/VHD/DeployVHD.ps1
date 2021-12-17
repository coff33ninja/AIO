########################################################## 
# 
# DeployVHD.ps1
#
# A PS Script to update a Windows 10 image with drivers, 
# features, and an answer file (optional). Image will then
# be deployed to a native boot VHD file, and added to 
# Windows bootmenu for dual / multi boot.
# 
# You are free to edit & share this script. Please mention
# source TenForums.com when shared.
#
# Script by Kari 
# - TenForums.com/members/kari.html
# - Twitter.com/KariTheFinn
# - YouTube.com/KariTheFinn
#
# 'Use-RunAs' function to check if script was launched
# in normal user mode and elevating it if necessary by
# Matt Painter (Microsoft TechNet Script Center)
# https://gallery.technet.microsoft.com/scriptcenter/ 
#
##########################################################


##########################################################
# Checking if PS is running elevated. If not, elevating it
##########################################################   

function Use-RunAs 
{    
    # Check if script is running as Administrator and if not, elevate it
    # Use Check Switch to check if admin 
     
    param([Switch]$Check) 
     
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()` 
        ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
         
    if ($Check) { return $IsAdmin }   
      
    if ($MyInvocation.ScriptName -ne "") 
    {  
        if (-not $IsAdmin)  
          {  
            try 
            {  
                $arg = "-file `"$($MyInvocation.ScriptName)`"" 
                Start-Process "$psHome\powershell.exe" -Verb Runas -ArgumentList $arg -ErrorAction 'stop'  
            } 
            catch 
            { 
                Write-Warning "Error - Failed to restart script elevated"  
                break               
            } 
            exit 
        }  
    }  
} 

Use-RunAs 

##########################################################
# Change these three variables as you wish:
#
# $WimFolder = Path to folder containing a valid Windows 10
# install.wim file. Default is D:\Wim. 
#
# $VHDLetter = A free driveletter, used as temporary drive
# letter for deploying Windows to VHD. Default is W
#
# $VHDSize = Size in MB for VHD that will be created.
# Default size is 100 GB (102400 MB).
#
##########################################################

$WimFolder = 'D:\Wim'
$VHDLetter = 'W'
$VHDSize = '102400'

##########################################################
# Static variables, do not change / edit!
##########################################################

$VHD = $VHDLetter + ':\'
$VHDWinDir = $VHD + 'Windows'
$VHDName = Join-Path $WimFolder '\W10.vhdx'
$MountFolder =  Join-Path $env:Temp '\Mount'
$DriverFolder = Join-Path $env:Temp '\Drivers'
$VHDConfig = Join-Path $env:Temp '\VHDConfig.txt'
$BootEntry = Join-Path $env:Temp '\Boot.bat'
$WimFile = Join-Path $WimFolder '\install.wim'
$CustomWim = Join-Path $WimFolder '\custom.wim'

cls

##########################################################
# Checking that a valid install.wim file is in WIM folder. 
##########################################################

Write-Host 'Checking if folder'$WimFolder 'contains a valid install.wim image...'
$WimCount = 0
while ($WimCount -eq 0) {
   
    if (Test-Path $WimFolder\install.wim)
        {
        $WimCount = 1
        }
    elseif (Test-Path $WimFolder)
        {
        $WimCount = 0
        cls
        Write-Host
        Write-Host ' No Windows image found. Please copy a valid'
        Write-Host ' install.wim to'$WimFolder 'and try again.'
        Write-Host ' ' -NoNewline
        Write-Host
        Pause
        }
    else
        {
        $WimCount = 0
        cls
        Write-Host
        Write-Host ' Path'$WimFolder 'does not exist.'
        Write-Host ' Create it and store valid install.wim file in it.'
        Write-Host
        Write-Host ' ' -NoNewline
        Pause
        }
    }

$WimFile = Join-Path $WimFolder '\install.wim'

##########################################################
# List Windows editions on image, prompt user for edition
# to be updated, exporting and mounting selected edition.
##########################################################

cls
Write-Host
Write-Host 'Checking WIM file...'
Get-WindowsImage -ImagePath $WimFile | Format-Table ImageIndex, ImageName
Write-Host ' The install.wim file contains above listed Windows editions.'
Write-Host ' Which edition should be mounted for offline servicing?'
Write-Host  
Write-Host ' Enter the ImageIndex number of correct edition and press Enter.'
Write-Host
$Edition = Read-Host -Prompt ' Select edition (ImageIndex)'
cls
Write-Host
Write-Host
Write-Host 'Exporting and mounting selected Windows edition.'
Write-Host
if (Test-Path $CustomWim) {Remove-Item $CustomWim}
Dism /Export-Image /SourceImageFile:$WimFile /SourceIndex:$Edition /DestinationImageFile:$CustomWim /DestinationName:'W10Custom' 
Write-Host
Write-Host
Write-Host ' Selected WIndows 10 edition exported to new WIM file.'
Write-Host
Write-Host ' Mounting'  $CustomWim
Write-Host
if (Test-Path $MountFolder) {Remove-Item $MountFolder}
$MountFolder = New-Item -ItemType Directory -Path $MountFolder
Mount-WindowsImage -ImagePath $CustomWim -Index 1 -Path $MountFolder

##########################################################
# Asking if user wants to add device drivers to WIM image
##########################################################

cls
Write-Host
Write-Host ' Do you want to add host device drivers to Windows 10 image?'
Write-Host
Write-Host ' It really is a good idea to add host device drivers to the VHD.'
Write-Host ' It will speed up fist boot of your native boot VHD, but can take a few'
Write-Host ' minutes now. It is your choice: not adding drivers now will make this process'
Write-Host ' faster, but will cause longer boot time and a long Windows Update process'
Write-Host ' to install all drivers, when VHD is booted first time.'
Write-Host
$AddDrivers = Read-Host -Prompt ' Do you want to add host device drivers to Windows image (Y or N)?'

    if (($AddDrivers -match 'Y') -or ($AddDrivers -match 'y'))
            {
            if (Test-Path $DriverFolder) {Remove-Item $DriverFolder -Recurse}
            $DriverFolder = New-Item -ItemType Directory -Path $DriverFolder
            Write-Host
            Write-Host
            Write-Host ' Exporting host drivers, adding them to Windows image. This can take quite a while.'
            dism /Online /Export-Driver /Destination:$DriverFolder 
            dism /Image:$MountFolder /Add-Driver /Driver:$DriverFolder /Recurse
            cls
            Write-Host
            Write-Host ' Host device drivers added to Windows image'
            }
    else
        {
        Write-Host
        Write-Host ' No device drivers added.'
        }
Write-Host

##########################################################
# Asking if user wants to add optional features to VHD,
# in this sample Hyper-V and Windows Subsystem for Linux. 
##########################################################

Write-Host
$Features = Read-Host -Prompt ' Do you want to add Hyper-V and Windows Subsystem for Linux features (Y or N)?'
    if (($Features -match 'Y') -or ($Features -match 'y'))
            {
            Write-Host
            Write-Host ' Enabling Hyper-V.'
            Write-Host
            Dism /Image:$MountFolder /Enable-Feature /FeatureName:Microsoft-Hyper-V-All /All
            Write-Host
            Write-Host ' Enabling Windows Subsystem for Linux.'
            Write-Host
            Dism /Image:$MountFolder /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All
            }
    else
        {
        Write-Host
        Write-Host ' No optional features added.'
        }    

##########################################################
# Checking if WIM folder contains an answer file 
# (unattend.xml). If found, asking user if it should
# be applied to Windows image.
##########################################################

if (Test-Path $WimFolder\unattend.xml){
    cls
    Write-Host
    Write-Host ' An answer file unattend.xml was found in'$WimFolder 
    Write-Host
    $Unattend = Read-Host -Prompt ' Do you want to apply this answer file to Windows imgage (Y or N)'
    if (($Unattend -match 'Y') -or ($Unattend -match 'y'))
        {
        New-Item -ItemType Directory -Force -Path $Mountfolder\Windows\Panther | Out-Null
        Copy-Item -Path $WimFolder\unattend.xml -Destination $Mountfolder\Windows\Panther -Force | Out-Null
        Write-Host
        Write-Host ' Answer file'$WimFolder\unattend.xml 'was applied to Windows image'
        Write-Host
        }
    }       

##########################################################
# Creating a new VHD file, 
##########################################################

Write-Host
Write-Host ' A new Virtual Hard Disk will be created in' $VHDName
            Write-Host ' Do you want to create an MBR or a GPT partitioned VHD?'
            Write-Host 
            $Disk = 0
            while ($Disk -eq 0) {
                $VHDType = Read-Host -Prompt ' Select M for MBR disk, G for GPT'
                if (($VHDType -match 'M') -or ($VHDType -match 'm'))
                    {
                    Write-Host
                    Write-Host ' Creating an MBR formatted virtual hard disk and mounting it'
                    Write-Host ' File Explorer might open new window showing' $VHDWinDir
                    Write-Host ' Close the window when / if it opens.'
                        if (Test-Path $VHDConfig) {Remove-Item $VHDConfig}
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
                    $Disk = 1
                    }
                elseif (($VHDType -match 'G') -or ($VHDType -match 'g'))
                    {
                    Write-Host
                    Write-Host ' Creating a GPT formatted virtual hard disk and mounting it.'
                    Write-Host ' File Explorer might open new window showing' $VHDWinDir
                    Write-Host ' Close the window when / if it opens.'
                        if (Test-Path $VHDConfig) {Remove-Item $VHDConfig}
                        Add-Content $VHDConfig "create vdisk file=$VHDName maximum=$VHDSize type=expandable"
                        Add-Content $VHDConfig "attach vdisk"
                        Add-Content $VHDConfig "convert gpt"
                        Add-Content $VHDConfig "create partition efi size=100"
                        Add-Content $VHDConfig "format quick fs=fat32 label=System"
                        Add-Content $VHDConfig "create partition msr size=16"
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
                    $Disk = 1
                    }
                else
                    {
                    Write-Host
                    Write-Host ' You selected no VHD type. Please try again.'
                    Write-Host ' ' -NoNewline
                    Pause
                    }      
                }

cls
Write-Host
Write-Host ' A new Virtual Hard Disk was created in' $VHDName
Write-Host ' Do you want to keep it and add it to boot menu,'
Write-Host ' or copy it to another location instead?'
Write-Host 
$VHDNewPath = $VHDName
$CreateVHD = Read-Host -Prompt ' Press Y to change VHD name and location, any other key to continue' 
    if (($CreateVHD -match 'Y') -or ($CreateVHD -match 'y'))
            {
            Write-Host
            Write-Host ' Enter new path (drive:\folder).'
            Write-Host
            Write-Host ' Examples:'
            Write-Host  
            Write-Host ' C:\Users\Downloads'
            Write-Host ' X:\Data\'
            Write-Host
            Write-Host ' Be sure that the source path (folder) exists.'
            Write-Host ' If you want to save VHD on root of a drive,' 
            Write-Host ' enter drive letter followed by : (examples: D: or X:)' 
            Write-Host
            $VHDNewFolder = Read-Host -Prompt ' Type the path, press Enter' 
            $FolderExists = 0
            while ($FolderExists -eq 0) {
                if (Test-Path $VHDNewFolder)
                    {
                    $FolderExists = 1
                    Write-Host
                    $VHDNewName = Read-Host -Prompt ' Type new name for VHD file (without extension)'
                    $VHDNewPath = $VHDNewFolder + '\' + $VHDNewName + '.vhdx'
                    }
                else
                    {
                    Write-Host
                    Write-Host ' Folder' $VHDNewFolder 'does not exist. Check the path and try again.'
                    Write-Host 
                    Pause
                    }
                }
        Copy-Item -Path $VHDName -Destination $VHDNewPath -Force
        Dismount-VHD -Path $VHDName
        Mount-VHD -Path $VHDNewPath
        Write-Host
            }

##########################################################
# Saving changes to custom.wim file.
##########################################################
cls
Write-Host ' Saving changes to custom WIM image. This will take a few minutes.'
Write-Host
Dismount-WindowsImage -Save -Path $MountFolder | Out-Null 
cls
Write-Host
Write-Host ' Deploying Windows to VHD file.' 
Write-Host
Write-Host ' Depending on your hardware and if VHD is stored on SSD'
Write-Host ' or HDD, this can take anything between 2 and 20 minutes.'
Write-Host
dism /apply-image /imagefile:$CustomWim /index:1 /applydir:$VHD

##########################################################
# Adding VHD to boot menu. 
##########################################################

cls
Write-Host
Write-Host ' Creating boot records.'
Write-Host
    cmd /c C:\Windows\System32\bcdboot.exe $VHDWinDir

##########################################################
# Renaming boot entry. 
##########################################################

$BootEntry = Join-Path $env:Temp '\boot.bat'
    if (Test-Path $BootEntry) {Remove-Item $BootEntry}
    Add-Content $BootEntry "%windir%\System32\bcdedit.exe /set {default} description Windows10-VHD"
    cmd /c $BootEntry

##########################################################
# All done! 
##########################################################

Write-Host
Write-Host ' Windows has been deployed to VHD' $VHDNewPath
Write-Host ' and added to host boot menu as Windows10-VHD' 
Write-Host
Write-Host ' Folder' $WimFolder 'contains now your original,'
Write-Host ' unchanged install.wim file, customized new WIM'
Write-Host ' file custom.wim, and VHD file W10.vhdx, which'
Write-Host ' must be deleted before running the script again.'
Write-Host 

pause

##########################################################
# End of script
##########################################################