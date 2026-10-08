[CmdletBinding()]
param(
    [int]$Bands = 120,
    [int]$BarWidth = 5,
    [int]$Step = 6,
    [int]$Height = 200,
    [int]$ReflectionHeight = 80
)

$ErrorActionPreference = 'Stop'

$skinRoot = Split-Path -Parent $PSScriptRoot
New-Item -ItemType Directory -Path (Join-Path $skinRoot 'Visualizer') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $skinRoot 'Visualizer_L') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $skinRoot 'Visualizer_R') -Force | Out-Null

$leftAnchor = 779
$rightAnchor = 785

function Add-Line {
    param(
        [System.Text.StringBuilder]$Builder,
        [string]$Text = ''
    )

    [void]$Builder.AppendLine($Text)
}

function New-Visualizer {
    param(
        [ValidateSet('Default', 'NoReflection', 'LeftOnly', 'RightOnly')]
        [string]$Mode,
        [string]$Path
    )

    $builder = [System.Text.StringBuilder]::new()
    $hasLeft = $Mode -ne 'RightOnly'
    $hasRight = $Mode -ne 'LeftOnly'
    $hasReflection = $Mode -eq 'Default'

    Add-Line $builder '[Rainmeter]'
    Add-Line $builder 'Update=0'
    Add-Line $builder 'BackgroundMode=2'
    Add-Line $builder 'SolidColor=0,0,0,1'
    Add-Line $builder ''
    Add-Line $builder '[Metadata]'
    Add-Line $builder 'Author=WenqiOfficial'
    Add-Line $builder 'License=MIT'
    Add-Line $builder ''
    Add-Line $builder '[Variables]'
    Add-Line $builder '@include=#@#Theme\Settings.inc'
    Add-Line $builder 'BarRefl=255,255,255,50'
    Add-Line $builder 'LineColor=255,255,255'
    Add-Line $builder ''

    Add-Line $builder '[MeasureAudio]'
    Add-Line $builder 'Measure=Plugin'
    Add-Line $builder 'Plugin=AudioLevel'
    Add-Line $builder 'Port=Output'
    Add-Line $builder 'FFTSize=2048'
    Add-Line $builder 'FFTOverlap=128'
    Add-Line $builder 'FFTAttack=20'
    Add-Line $builder 'FFTDecay=150'
    Add-Line $builder 'FreqMin=130'
    Add-Line $builder 'FreqMax=16500'
    Add-Line $builder 'Sensitivity=32'
    Add-Line $builder "Bands=$($Bands + 1)"
    Add-Line $builder ''

    for ($i = 1; $i -le $Bands; $i++) {
        $id = '{0:D2}' -f $i

        if ($hasLeft) {
            Add-Line $builder "[mL$id]"
            Add-Line $builder 'Measure=Plugin'
            Add-Line $builder 'Plugin=AudioLevel'
            Add-Line $builder 'Parent=MeasureAudio'
            Add-Line $builder 'Type=Band'
            Add-Line $builder 'Channel=L'
            Add-Line $builder "BandIdx=$i"
            Add-Line $builder 'AverageSize=6'
            Add-Line $builder ''
        }

        if ($hasRight) {
            Add-Line $builder "[mR$id]"
            Add-Line $builder 'Measure=Plugin'
            Add-Line $builder 'Plugin=AudioLevel'
            Add-Line $builder 'Parent=MeasureAudio'
            Add-Line $builder 'Type=Band'
            Add-Line $builder 'Channel=R'
            Add-Line $builder "BandIdx=$i"
            Add-Line $builder 'AverageSize=6'
            Add-Line $builder ''
        }
    }

    Add-Line $builder '[StyleMain]'
    Add-Line $builder 'BarOrientation=Vertical'
    Add-Line $builder 'Y=5'
    Add-Line $builder "W=$BarWidth"
    Add-Line $builder "H=$Height"
    Add-Line $builder 'BarColor=255,255,255'
    Add-Line $builder ''

    if ($hasReflection) {
        Add-Line $builder '[StyleRefl]'
        Add-Line $builder 'BarOrientation=Vertical'
        Add-Line $builder 'Y=208'
        Add-Line $builder "W=$BarWidth"
        Add-Line $builder "H=$ReflectionHeight"
        Add-Line $builder 'Flip=1'
        Add-Line $builder 'BarColor=255,255,255,50'
        Add-Line $builder ''
    }

    for ($i = 1; $i -le $Bands; $i++) {
        $id = '{0:D2}' -f $i

        if ($hasLeft) {
            $x = $leftAnchor - (($i - 1) * $Step)
            Add-Line $builder "[BandL$id]"
            Add-Line $builder 'Meter=Bar'
            Add-Line $builder 'MeterStyle=StyleMain'
            Add-Line $builder "MeasureName=mL$id"
            Add-Line $builder "X=$x"
            Add-Line $builder ''
        }

        if ($hasRight) {
            $x = $rightAnchor + (($i - 1) * $Step)
            Add-Line $builder "[BandR$id]"
            Add-Line $builder 'Meter=Bar'
            Add-Line $builder 'MeterStyle=StyleMain'
            Add-Line $builder "MeasureName=mR$id"
            Add-Line $builder "X=$x"
            Add-Line $builder ''
        }

        if ($hasReflection) {
            $leftX = $leftAnchor - (($i - 1) * $Step)
            $rightX = $rightAnchor + (($i - 1) * $Step)

            Add-Line $builder "[ReflL$id]"
            Add-Line $builder 'Meter=Bar'
            Add-Line $builder 'MeterStyle=StyleRefl'
            Add-Line $builder 'Hidden=#HideVizReflection#'
            Add-Line $builder "MeasureName=mL$id"
            Add-Line $builder "X=$leftX"
            Add-Line $builder ''

            Add-Line $builder "[ReflR$id]"
            Add-Line $builder 'Meter=Bar'
            Add-Line $builder 'MeterStyle=StyleRefl'
            Add-Line $builder 'Hidden=#HideVizReflection#'
            Add-Line $builder "MeasureName=mR$id"
            Add-Line $builder "X=$rightX"
            Add-Line $builder ''
        }
    }

    Add-Line $builder '[LineL]'
    Add-Line $builder 'Meter=Image'
    Add-Line $builder 'ImageName=#@#Images\Line.png'
    Add-Line $builder 'X=0'
    Add-Line $builder 'Y=206'
    Add-Line $builder 'W=850'
    Add-Line $builder 'H=1'
    Add-Line $builder 'ImageTint=#LineColor#'
    Add-Line $builder ''

    Add-Line $builder '[LineR]'
    Add-Line $builder 'Meter=Image'
    Add-Line $builder 'ImageName=#@#Images\Line.png'
    Add-Line $builder 'X=720'
    Add-Line $builder 'Y=206'
    Add-Line $builder 'W=850'
    Add-Line $builder 'H=1'
    Add-Line $builder 'ImageTint=#LineColor#'

    [System.IO.File]::WriteAllText($Path, $builder.ToString(), [System.Text.UTF8Encoding]::new($false))
    Write-Host "Generated $Path"
}

New-Visualizer -Mode Default -Path (Join-Path $skinRoot 'Visualizer\Visualizer.ini')
New-Visualizer -Mode NoReflection -Path (Join-Path $skinRoot 'Visualizer\Visualizer_NoRefl.ini')
New-Visualizer -Mode LeftOnly -Path (Join-Path $skinRoot 'Visualizer_L\Visualizer_Left.ini')
New-Visualizer -Mode RightOnly -Path (Join-Path $skinRoot 'Visualizer_R\Visualizer_Right.ini')
