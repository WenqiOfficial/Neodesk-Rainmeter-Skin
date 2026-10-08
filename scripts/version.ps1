[CmdletBinding()]
param(
    [string]$Release
)

if ($Release) {
    $resolved = $Release.Trim()
} elseif ($env:GITHUB_REF_TYPE -eq 'tag') {
    $resolved = $env:GITHUB_REF_NAME
} else {
    $resolved = 'dev+' + (Get-Date -Format 'yyyyMMddHHmm')
}

$resolved = $resolved -replace '^v', '' -replace '\s', '-'

if ([string]::IsNullOrWhiteSpace($resolved)) {
    throw 'Version cannot be empty.'
}

Write-Output $resolved
