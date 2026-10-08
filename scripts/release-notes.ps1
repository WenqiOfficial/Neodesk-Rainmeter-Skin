[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$OutputPath = 'dist\RELEASE_NOTES.md'
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$changelogPath = Join-Path $repo 'CHANGELOG.md'

if (-not (Test-Path -LiteralPath $changelogPath)) {
    throw 'CHANGELOG.md is required.'
}

$changelog = Get-Content -LiteralPath $changelogPath -Raw
$escapedVersion = [regex]::Escape($Version)
$pattern = "(?ms)^##\s+$escapedVersion(?:\s*-\s*[^\r\n]+)?\r?\n(.*?)(?=^##\s|\z)"
$match = [regex]::Match($changelog, $pattern)

if ($match.Success) {
    $changes = $match.Groups[1].Value.Trim()
}
else {
    $changes = 'See the commit history for details.'
}

$bodyLines = @(
    "## NeoDesk $Version",
    "",
    $changes,
    "",
    "### Assets",
    "",
    "- NeoDesk_$Version.zip",
    "- NeoDesk_$Version.zip.sha256"
)

$body = $bodyLines -join [Environment]::NewLine

$fullOutputPath = Join-Path $repo $OutputPath
$outputDir = Split-Path -Parent $fullOutputPath
if ($outputDir -and -not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

Set-Content -LiteralPath $fullOutputPath -Value $body -Encoding UTF8
Write-Host "Release notes written to $fullOutputPath"
