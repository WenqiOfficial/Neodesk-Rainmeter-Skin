[CmdletBinding()]
param(
    [string]$Path = 'NeoDesk',
    [switch]$Fix
)

$ErrorActionPreference = 'Stop'

$repo = Split-Path -Parent $PSScriptRoot
$target = if ([System.IO.Path]::IsPathRooted($Path)) {
    $Path
} else {
    Join-Path $repo $Path
}
$extensions = @('.ini', '.inc', '.txt', '.lua')

if (-not (Test-Path -LiteralPath $target)) {
    throw "Encoding target does not exist: $target"
}

$files = Get-ChildItem -LiteralPath $target -Recurse -File |
    Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() }

if (-not $files) {
    throw 'No runtime skin files were found to check.'
}

$invalid = @()

foreach ($file in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $hasUtf16Bom = $bytes.Length -ge 2 -and
        $bytes[0] -eq 0xFF -and
        $bytes[1] -eq 0xFE

    if (-not $hasUtf16Bom -or ($bytes.Length % 2) -ne 0) {
        if ($Fix) {
            $text = [System.IO.File]::ReadAllText(
                $file.FullName,
                [System.Text.Encoding]::UTF8
            )
            [System.IO.File]::WriteAllText(
                $file.FullName,
                $text,
                [System.Text.Encoding]::Unicode
            )
            Write-Host "Converted to UTF-16 LE BOM: $($file.FullName)"
        }
        else {
            $invalid += $file.FullName
        }
    }
}

if ($invalid.Count -gt 0) {
    $invalid | ForEach-Object { Write-Error "Invalid UTF-16 LE BOM: $_" }
    exit 1
}

Write-Host "Encoding check passed: $($files.Count) runtime skin files are UTF-16 LE BOM."
