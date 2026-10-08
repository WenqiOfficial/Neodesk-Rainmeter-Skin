# =================================================================
# NeoDesk - Visualizer generator
# Generates ..\Visualizer\Visualizer.ini - a single merged stereo
# visualizer matching the original mirrored design: white main bars,
# alpha-50 flipped reflections (toggle via HideVizReflection in
# Settings.inc), fading baseline (Line.png x2). Update=0, plugin-driven.
# One shared AudioLevel FFT (was two). No third-party plugins.
# =================================================================

param(
  [int]$Bands = 120,
  [int]$BarW  = 5,
  [int]$Step  = 6,
  [int]$H     = 200,
  [int]$RefH  = 80
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path (Split-Path $here -Parent) -Parent
$out  = Join-Path $root 'Visualizer\Visualizer.ini'

# Window X = 175 (same as original L window).
# L band i window-x = 779 - (i-1)*6 ; R band i = 785 + (i-1)*6
$l0 = 779
$r0 = 785

$sb = New-Object System.Text.StringBuilder
function Add($s) { [void]$sb.AppendLine($s) }

Add '[Rainmeter]'
Add 'Update=0'
Add 'Author=NeoDesk'
Add 'BackgroundMode=2'
Add 'SolidColor=0,0,0,1'
Add ''
Add '[Variables]'
Add '@include=#@#Theme\Settings.inc'
Add 'BarRefl=255,255,255,50'
Add 'LineColor=255,255,255'
Add ''

# ---- audio engine: one parent shared by both channels ----
Add '; ---------------- audio engine ----------------'
Add '[MeasureAudio]'
Add 'Measure=Plugin'
Add 'Plugin=AudioLevel'
Add 'Port=Output'
Add 'FFTSize=4096'
Add 'FFTOverlap=4096'
Add 'FFTAttack=150'
Add 'FFTDecay=100'
Add 'FreqMin=100'
Add 'FreqMax=16500'
Add 'Sensitivity=32'
Add ("Bands=" + ($Bands + 1))
Add ''

for ($i = 1; $i -le $Bands; $i++) {
  $id = '{0:D2}' -f $i
  Add "[mL$id]"
  Add 'Measure=Plugin'
  Add 'Plugin=AudioLevel'
  Add 'Parent=MeasureAudio'
  Add 'Type=Band'
  Add 'Channel=L'
  Add "BandIdx=$i"
  Add 'AverageSize=6'
  Add ''
}
for ($i = 1; $i -le $Bands; $i++) {
  $id = '{0:D2}' -f $i
  Add "[mR$id]"
  Add 'Measure=Plugin'
  Add 'Plugin=AudioLevel'
  Add 'Parent=MeasureAudio'
  Add 'Type=Band'
  Add 'Channel=R'
  Add "BandIdx=$i"
  Add 'AverageSize=6'
  Add ''
}

# ---- meter styles ----
Add '; ---------------- meter styles ----------------'
Add '[StyleMain]'
Add 'BarOrientation=Vertical'
Add 'Y=5'
Add "W=$BarW"
Add "H=$H"
Add 'BarColor=255,255,255'
Add ''
Add '[StyleRefl]'
Add 'BarOrientation=Vertical'
Add 'Y=208'
Add "W=$BarW"
Add "H=$RefH"
Add 'Flip=1'
Add 'BarColor=255,255,255,50'
Add ''

# ---- main bars ----
Add '; ---------------- main bars ----------------'
for ($i = 1; $i -le $Bands; $i++) {
  $id = '{0:D2}' -f $i
  $x = $l0 - ($i - 1) * $Step
  Add "[BandL$id]"
  Add 'Meter=Bar'
  Add 'MeterStyle=StyleMain'
  Add "MeasureName=mL$id"
  Add "X=$x"
  Add ''
}
for ($i = 1; $i -le $Bands; $i++) {
  $id = '{0:D2}' -f $i
  $x = $r0 + ($i - 1) * $Step
  Add "[BandR$id]"
  Add 'Meter=Bar'
  Add 'MeterStyle=StyleMain'
  Add "MeasureName=mR$id"
  Add "X=$x"
  Add ''
}

# ---- reflections ----
Add '; ---------------- reflections ----------------'
for ($i = 1; $i -le $Bands; $i++) {
  $id = '{0:D2}' -f $i
  $x = $l0 - ($i - 1) * $Step
  Add "[ReflL$id]"
  Add 'Meter=Bar'
  Add 'MeterStyle=StyleRefl'
  Add 'Hidden=#HideVizReflection#'
  Add "MeasureName=mL$id"
  Add "X=$x"
  Add ''
}
for ($i = 1; $i -le $Bands; $i++) {
  $id = '{0:D2}' -f $i
  $x = $r0 + ($i - 1) * $Step
  Add "[ReflR$id]"
  Add 'Meter=Bar'
  Add 'MeterStyle=StyleRefl'
  Add 'Hidden=#HideVizReflection#'
  Add "MeasureName=mR$id"
  Add "X=$x"
  Add ''
}

# ---- fading baseline (two Line.png, same placement as originals) ----
Add '; ---------------- baseline ----------------'
Add '[LineL]'
Add 'Meter=Image'
Add 'ImageName=#@#Images\Line.png'
Add 'X=0'
Add 'Y=206'
Add 'W=850'
Add 'H=1'
Add 'ImageTint=#LineColor#'
Add 'DynamicVariables=1'
Add ''
Add '[LineR]'
Add 'Meter=Image'
Add 'ImageName=#@#Images\Line.png'
Add 'X=720'
Add 'Y=206'
Add 'W=850'
Add 'H=1'
Add 'ImageTint=#LineColor#'
Add 'DynamicVariables=1'
Add ''

[IO.File]::WriteAllText($out, $sb.ToString(), (New-Object Text.ASCIIEncoding))
Write-Output ("Wrote " + $out + "  (" + (Get-Item $out).Length + " bytes)")
