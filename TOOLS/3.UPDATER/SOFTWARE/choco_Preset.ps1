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