# Set the execution policy silently
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 2> $null
Set-ExecutionPolicy -ExecutionPolicy Unrestricted 2> $null

# Clear the content of the folder
Remove-Item -Path 'C:\temp' -Force -Recurse

# Set the console window size and title
$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(98, 32)
$Host.UI.RawUI.WindowTitle = 'SOFTWARE UPDATER'

# Define colors for output
$green = [ConsoleColor]::Green
$yellow = [ConsoleColor]::Yellow
$red = [ConsoleColor]::Red

# Display introductory message
Write-Host 'The script will automatically download and install package managers that will give an indication'
Write-Host 'of what you as a user would be able to use for the rest of the script. A few items will be changed'
Write-Host 'to make it much more visible to use with color-based indicators.'

# Check if Chocolatey is already installed
try {
    if (Get-Command choco -ErrorAction Stop) {
        Write-Host 'Chocolatey is already installed.' -ForegroundColor $green
        $chocoInstalled = $true
    }
}
catch {
    Write-Host 'Installing Chocolatey...' -ForegroundColor $yellow
    try {
        Invoke-WebRequest -Uri 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
        $chocoInstalled = $true
    }
    catch {
        Write-Host 'Failed to install Chocolatey.' -ForegroundColor $red
        exit
    }
}

# Check if other package managers are installed and install them if necessary
$wgetInstalled = $false
$curlInstalled = $false
$aria2Installed = $false
$wingetInstalled = $false

try {
    if (-not (Get-Command wget -ErrorAction Stop)) {
        Write-Host 'Installing wget...' -ForegroundColor $yellow
        try {
            choco install -y wget
            $wgetInstalled = $true
        }
        catch {
            Write-Host 'Failed to install wget.' -ForegroundColor $red
        }
    }
    else {
        $wgetInstalled = $true
    }

    if (-not (Get-Command curl -ErrorAction Stop)) {
        Write-Host 'Installing curl...' -ForegroundColor $yellow
        try {
            choco install -y curl
            $curlInstalled = $true
        }
        catch {
            Write-Host 'Failed to install curl.' -ForegroundColor $red
        }
    }
    else {
        $curlInstalled = $true
    }

    if (-not (Get-Command aria2c -ErrorAction Stop)) {
        Write-Host 'Installing aria2...' -ForegroundColor $yellow
        try {
            choco install -y aria2
            $aria2Installed = $true
        }
        catch {
            Write-Host 'Failed to install aria2.' -ForegroundColor $red
        }
    }
    else {
        $aria2Installed = $true
    }

    if (-not (Get-Command winget -ErrorAction Stop)) {
        if (-not $curlInstalled) {
            Write-Host 'Winget and Curl are not installed. Please download and install the Windows Package Manager and curl manually and then re-run this script.' -ForegroundColor $red
            exit
        }
        else {
            Write-Host 'Installing winget...' -ForegroundColor $yellow
            try {
                Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
                Install-Script -Name winget-install -Force
                Add-AppxPackage https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
                $wingetInstalled = $true
            }
            catch {
                Write-Host 'Failed to install winget.' -ForegroundColor $red
            }
        }
    }
    else {
        $wingetInstalled = $true
    }
}
catch {
    Write-Host 'An error occurred while installing package managers.' -ForegroundColor $red
    exit
}

# Display status of installed package managers
Clear-Host
Write-Host "Chocolatey installed: $chocoInstalled" -ForegroundColor $green
Write-Host "Wget installed: $wgetInstalled" -ForegroundColor $green
Write-Host "Winget installed: $wingetInstalled" -ForegroundColor $green
Write-Host "Curl installed: $curlInstalled" -ForegroundColor $green
Write-Host "Aria2 installed: $aria2Installed" -ForegroundColor $green
Write-Host
Write-Host 'You can now choose whether to go back to the previous menu or continue with selections'
Write-Host 'showcased below.'
Pause

# Check if PowerShell is up-to-date
if ($chocoInstalled) {
    try {
        if (Get-Command powershell -ErrorAction Stop) {
            $installedVersion = (Get-Command powershell).FileVersionInfo.ProductVersion
            $latestVersion = ((Invoke-WebRequest -Uri 'https://chocolatey.org/api/v2/package/powershell').Content | ConvertFrom-Json).Version
            if ($installedVersion -ge $latestVersion) {
                Write-Host "PowerShell is already up-to-date (version $installedVersion)."
            }
            else {
                Write-Host 'Updating PowerShell...'
                try {
                    choco upgrade powershell -y
                }
                catch {
                    Write-Host 'Failed to update PowerShell.' -ForegroundColor $red
                }
            }
        }
        else {
            Write-Host 'PowerShell is not installed. Please download and install PowerShell manually.'
        }
    }
    catch {
        Write-Host 'An error occurred while checking or updating PowerShell.' -ForegroundColor $red
    }
}
elseif ($wingetInstalled) {
    try {
        $psVersion = (winget list -e --id Microsoft.PowerShell | ConvertFrom-Json).versions[0].version
        if ($null -eq $psVersion) {
            Write-Host 'PowerShell is not installed. Please download and install PowerShell manually.'
        }
        elseif ($psVersion -ge '7.0.0') {
            Write-Host "PowerShell is already up-to-date (version $psVersion)."
        }
        else {
            Write-Host 'Updating PowerShell...'
            try {
                winget install -e --id Microsoft.PowerShell
            }
            catch {
                Write-Host 'Failed to update PowerShell.' -ForegroundColor $red
            }
        }
    }
    catch {
        Write-Host 'An error occurred while checking or updating PowerShell.' -ForegroundColor $red
    }
}

# Check if the 'C:\temp' directory exists
if (-not (Test-Path 'C:\temp')) {
    # Create the 'C:\temp' directory
    try {
        New-Item -ItemType Directory -Path 'C:\temp'
    }
    catch {
        Write-Host 'Failed to create the C:\temp directory.' -ForegroundColor $red
        exit
    }
}

# Disable the first-run check for Internet Explorer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1

# Download the AIO.cmd file using different download tools with failover approach
$downloaded = $false
$urls = @(
    'https://raw.githubusercontent.com/coff33ninja/AIO/testing-irm-new-layout/AIO.cmd'
)
$tools = @(
    { curl $urls[0] -O 'C:\temp\AIO.cmd' -s },
    { wget -O -P 'C:\temp\AIO.cmd' $urls[0] },
    { aria2c $urls[0] -d C:\temp --allow-overwrite="true" --disable-ipv6 },
    { Invoke-RestMethod $urls[0] -OutFile 'C:\temp\AIO.cmd' -UseBasicParsing },
    { Invoke-WebRequest $urls[0] -OutFile 'C:\temp\AIO.cmd' -UseBasicParsing }
)
foreach ($tool in $tools) {
    try {
        & $tool
        if (Test-Path 'C:\temp\AIO.cmd') {
            $downloaded = $true
            break
        }
    }
    catch {
        Write-Host "$($_.Exception.Message)" -ForegroundColor $red
    }
}
if (-not $downloaded) {
    Write-Host 'Failed to download AIO.cmd file from all sources.' -ForegroundColor $red
    exit
}

# Download the cmdmenusel.exe file using different download tools with failover approach
$downloaded = $false
$urls = @(
    'https://raw.githubusercontent.com/coff33ninja/AIO/testing-irm-new-layout/Files/cmdmenusel.exe'
)
$tools = @(
    { curl $urls[0] -O 'C:\temp\files\cmdmenusel.exe' -s },
    { wget -O -P 'C:\temp\files\cmdmenusel.exe' $urls[0] },
    { aria2c $urls[0] -d C:\temp\files --allow-overwrite="true" --disable-ipv6 },
    { Invoke-RestMethod $urls[0] -OutFile 'C:\temp\files\cmdmenusel.exe' },
    { Invoke-WebRequest $urls[0] -OutFile 'C:\temp\files\cmdmenusel.exe' }
)
foreach ($tool in $tools) {
    try {
        & $tool
        if (Test-Path 'C:\temp\files\cmdmenusel.exe') {
            $downloaded = $true
            break
        }
    }
    catch {
        Write-Host "$($_.Exception.Message)" -ForegroundColor $red
    }
}
if (-not $downloaded) {
    Write-Host 'Failed to download cmdmenusel.exe file from all sources.' -ForegroundColor $red
    exit
}

# Run the downloaded AIO.cmd file in a separate window
Write-Host 'Running AIO.cmd file...'
try {
    Start-Process -FilePath 'C:\temp\AIO.cmd' -WindowStyle Normal -Wait
    Write-Host 'AIO.cmd file execution completed successfully.' -ForegroundColor $green
}
catch {
    Write-Host 'Failed to run AIO.cmd file.' -ForegroundColor $red
}

# Clear the content of the folder
try {
    Remove-Item -Path 'C:\temp' -Force -Recurse
}
catch {
    Write-Host 'Failed to clear the content of the C:\temp folder.' -ForegroundColor $red
}

# Pause the script before exiting
Write-Host
Write-Host 'Press any key to exit...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# I just hate leaving my trash behind XD

# https://github.com/MScholtes/PS2EXE