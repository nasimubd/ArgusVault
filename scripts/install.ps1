[CmdletBinding()]
param([string]$Repository = "nasimubd/ArgusVault", [string]$InstallDir = "$env:LOCALAPPDATA\Argus\bin")
$ErrorActionPreference = "Stop"
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repository/releases/latest"
$version = $release.tag_name.TrimStart("v")
$architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
switch ($architecture) {
  "X64" { $arch = "amd64" }
  "Arm64" { $arch = "arm64" }
  default { throw "unsupported Windows architecture: $architecture" }
}
$assetName = "argus_${version}_windows_${arch}.zip"
$asset = $release.assets | Where-Object { $_.name -eq $assetName }
$checksums = $release.assets | Where-Object { $_.name -eq "checksums.txt" }
if ($null -eq $asset -or $null -eq $checksums) { throw "release assets are unavailable" }
$temp = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $temp | Out-Null
try {
  $archive = Join-Path $temp $assetName
  $checksumFile = Join-Path $temp "checksums.txt"
  Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
  Invoke-WebRequest -Uri $checksums.browser_download_url -OutFile $checksumFile
  $expected = ((Get-Content $checksumFile | Where-Object { $_ -match "\s$([regex]::Escape($assetName))$" }) -split "\s+")[0]
  $actual = (Get-FileHash -Algorithm SHA256 -Path $archive).Hash
  if ($actual -ne $expected) { throw "checksum verification failed" }
  $extract = Join-Path $temp "extract"
  Expand-Archive -Path $archive -DestinationPath $extract
  New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
  Copy-Item (Join-Path $extract "argus.exe") (Join-Path $InstallDir "argus.exe") -Force
  '@echo off' + "`r`n" + '"%~dp0argus.exe" _codex %*' | Set-Content (Join-Path $InstallDir "argus-codex.bat") -Encoding ascii
  $userPath = [string][Environment]::GetEnvironmentVariable("Path", "User")
  if (($userPath -split ';') -notcontains $InstallDir) {
    $updatedPath = $InstallDir
    if ($userPath.Length -gt 0) { $updatedPath = "$($userPath.TrimEnd(';'));$InstallDir" }
    [Environment]::SetEnvironmentVariable("Path", $updatedPath, "User")
  }
  if (($env:Path -split ';') -notcontains $InstallDir) { $env:Path += ";$InstallDir" }
  & (Join-Path $InstallDir "argus.exe") --version
  Write-Output "installed Argus $($release.tag_name) in $InstallDir"
} finally { Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue }
