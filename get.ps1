$ErrorActionPreference = 'Stop'
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://github.com/coff33ninja/AIO/blob/testing-irm-new-layout/AIO.cmd'
$DownloadURL2 = 'https://raw.githubusercontent.com/coff33ninja/AIO/testing-irm-new-layout/AIO.cmd'

$rand = Get-Random -Maximum 1000
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\AIO_$rand.cmd" } else { "$env:TEMP\AIO_$rand.cmd" }

try {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $DownloadURL2 -UseBasicParsing
}

$ScriptArgs = "$args "
$prefix = "@REM $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\AIO*.cmd", "$env:SystemRoot\Temp\AIO*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
