choco install adobeair
choco install adobeshockwaveplayer
choco install javaruntime
choco install netfx-repair-tool
choco install dogtail.dotnet3.5sp1
choco install dotnet4.0
choco install dotnet4.5
choco install dotnet4.6.1
choco install netfx-4.7.1
choco install netfx-4.8
choco install dotnetfx
choco install silverlight
choco install vcredist-all
choco install python2
choco install python3
choco install googlechrome
choco install edgedeflector
choco install firefox
choco install k-litecodecpackfull
choco install k-litecodecpackmega
choco install vlc
choco install 7zip
choco install adobereader
choco install cdburnerxp
choco install skype
choco install winaero-tweaker
choco install anydesk.install
choco install teamviewer


$Packages = 'googlechrome',
            'git',
            'adobeair',
            'adobeshockwaveplayer',
            'javaruntime',
            'netfx-repair-tool',
            'dogtail.dotnet3.5sp1',
            'dotnet4.0',
            'dotnet4.5',
            'dotnet4.6.1',
            'netfx-4.7.1',
            'netfx-4.8',
            'dotnetfx',
            'silverlight',
            'vcredist-all',
            'python2',
            'python3',
            'googlechrome',
            'firefox',
            'edgedeflector',
            'k-litecodecpackfull',
            'k-litecodecpackmega',
            'vlc',
            '7zip',
            'adobereader',
            'cdburnerxp',
            'skype',
            'winaero-tweaker',
            'anydesk.install',
            'teamviewer'




 
If(Test-Path -Path "$env:ProgramData\Chocolatey") {
  # DoYourPackageInstallStuff
  ForEach ($PackageName in $Packages)
    {
        choco install $PackageName -y
    }
}
Else {
  # InstallChoco
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))      

  # DoYourPackageInstallStuff
  ForEach ($PackageName in $Packages)
    {
        choco install $PackageName -y
    }
}