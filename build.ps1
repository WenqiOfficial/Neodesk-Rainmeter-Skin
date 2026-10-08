[CmdletBinding()]
param(
    [string]$Release,
    [string]$OutputDir = 'dist'
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path

& (Join-Path $repo 'scripts/check-encoding.ps1') -Path (Join-Path $repo 'NeoDesk')

$resolvedVersion = (& (Join-Path $repo 'scripts/version.ps1') -Release $Release).Trim()
$buildRoot = Join-Path $repo 'build'
$stage = Join-Path $buildRoot 'NeoDesk'
$outDir = Join-Path $repo $OutputDir
$zipPath = Join-Path $outDir ("NeoDesk_{0}.zip" -f $resolvedVersion)
$hashPath = "$zipPath.sha256"

if (Test-Path -LiteralPath $buildRoot) {
    Remove-Item -LiteralPath $buildRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $stage -Force | Out-Null
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

Copy-Item -LiteralPath (Join-Path $repo 'NeoDesk') -Destination $buildRoot -Recurse -Force

foreach ($doc in @('README.md', 'README.zh-CN.md', 'LICENSE', 'CHANGELOG.md')) {
    Copy-Item -LiteralPath (Join-Path $repo $doc) -Destination $stage -Force
}

Copy-Item -LiteralPath (Join-Path $repo 'docs') -Destination $stage -Recurse -Force

function Get-FileEncoding {
    param([string]$Path)

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
        return [System.Text.Encoding]::Unicode
    }
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        return [System.Text.UTF8Encoding]::new($true)
    }
    return [System.Text.UTF8Encoding]::new($false)
}

function Update-TextFile {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Replacement
    )

    $encoding = Get-FileEncoding -Path $Path
    $text = [System.IO.File]::ReadAllText($Path, $encoding)
    $text = [regex]::Replace($text, $Pattern, $Replacement)
    [System.IO.File]::WriteAllText($Path, $text, $encoding)
}

$versionInc = Join-Path $stage '@Resources\Theme\Version.inc'
Update-TextFile -Path $versionInc -Pattern '(?m)^Version=.*$' -Replacement ("Version={0}" -f $resolvedVersion)

Get-ChildItem -LiteralPath $stage -Recurse -Filter '*.ini' | ForEach-Object {
    Update-TextFile -Path $_.FullName -Pattern '(?m)^Version=.*$' -Replacement ("Version={0}" -f $resolvedVersion)
}

Compress-Archive -Path $stage -DestinationPath $zipPath -Force

$hash = Get-FileHash -LiteralPath $zipPath -Algorithm SHA256
("$($hash.Hash)  $(Split-Path -Leaf $zipPath)") | Set-Content -LiteralPath $hashPath -Encoding ASCII

Write-Host "NeoDesk build complete."
Write-Host "Version: $resolvedVersion"
Write-Host "Package: $zipPath"
Write-Host "SHA256:  $hashPath"
