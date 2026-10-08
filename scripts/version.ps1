[CmdletBinding()]
param(
    [string]$Version
)

function Get-NeoDeskVersion {
    if ($Version) {
        $v = $Version.Trim() -replace '^v', ''
    }
    elseif ($env:GITHUB_REF_TYPE -eq 'tag') {
        $v = $env:GITHUB_REF_NAME -replace '^v', ''
    }
    else {
        $v = 'dev+' + (Get-Date -Format 'yyyyMMddHHmm')
    }

    $v = $v -replace '\s', '-'
    return $v
}

Get-NeoDeskVersion
