# =================================================================
# NeoDesk - Visualizer Multi-Version Generator
# Generates multiple Visualizer variants matching NeoDesk style:
#   1. Visualizer.ini         - Default Stereo with reflection toggle
#   2. Visualizer_NoRefl.ini  - Stereo without reflection meters
#   3. Visualizer_Left.ini    - Left channel only
#   4. Visualizer_Right.ini   - Right channel only
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
$vizDir = Join-Path $root 'Visualizer'
$vizDirL = Join-Path $root 'Visualizer_L'
$vizDirR = Join-Path $root 'Visualizer_R'

if (-not (Test-Path $vizDir)) {
    New-Item -ItemType Directory -Path $vizDir | Out-Null
}
if (-not (Test-Path $vizDirL)) {
    New-Item -ItemType Directory -Path $vizDirL | Out-Null
}
if (-not (Test-Path $vizDirR)) {
    New-Item -ItemType Directory -Path $vizDirR | Out-Null
}

# 基准 X 坐标 Anchor (与原版保持一致)
$l0 = 779
$r0 = 785

function Add-Line($sb, $text) {
    [void]$sb.AppendLine($text)
}

function Generate-VisualizerVariant {
    param(
        [string]$Mode,    # 'Default', 'NoRefl', 'LeftOnly', 'RightOnly'
        [string]$OutPath
    )

    $sb = New-Object System.Text.StringBuilder
    $hasL = ($Mode -ne 'RightOnly')
    $hasR = ($Mode -ne 'LeftOnly')

    Add-Line $sb '[Rainmeter]'
    Add-Line $sb 'Update=0'
    Add-Line $sb 'BackgroundMode=2'
    Add-Line $sb 'SolidColor=0,0,0,1'
    Add-Line $sb ''
    Add-Line $sb '[Metadata]' 
    Add-Line $sb 'Name='
    Add-Line $sb 'Author=WenqiOfficial'
    Add-Line $sb 'Information='
    Add-Line $sb 'License=MIT'
    Add-Line $sb 'Version='
    Add-Line $sb ''
    Add-Line $sb '[Variables]'
    Add-Line $sb '@include=#@#Theme\Settings.inc'
    if ($Mode -eq 'Default') {
        Add-Line $sb 'BarRefl=255,255,255,50'
    }
    Add-Line $sb 'LineColor=255,255,255'
    Add-Line $sb ''

    # ---- Audio Engine ----
    Add-Line $sb '; ---------------- Audio Engine (音频主引擎) ----------------'
    Add-Line $sb '[MeasureAudio]'
    Add-Line $sb 'Measure=Plugin'
    Add-Line $sb 'Plugin=AudioLevel'
    Add-Line $sb 'Port=Output'
    
    # [参数标注] FFTSize: 快速傅里叶变换窗口大小 (256 - 8192)。
    # 数值越大高低频解析度（频率分辨率）越高，但响应微有延迟且增加 CPU 消耗。
    Add-Line $sb 'FFTSize=2048'
    
    # [参数标注] FFTOverlap: 采样重叠度。
    # 控制 FFT 帧与帧之间的计算重叠程度，数值越大频谱过渡越连续平滑，稍许增加计算开销。
    Add-Line $sb 'FFTOverlap=128'
    
    # [参数标注] FFTAttack: 频谱柱上升响应缓冲时间 (毫秒)。
    # 数值越小对音量突变越敏感（上升迅猛），数值越大越平缓柔和。
    Add-Line $sb 'FFTAttack=20'
    
    # [参数标注] FFTDecay: 频谱柱下降衰减时间 (毫秒)。
    # 数值越小柱体下落越干脆（适合快节奏），数值越大下落越慢（富有余韵感）。
    Add-Line $sb 'FFTDecay=150'
    
    # [参数标注] FreqMin / FreqMax: 频谱捕捉范围 (Hz)。
    # 过滤掉低于 100Hz 的次声波/杂音以及高于 16.5kHz 人耳不敏感的高频。
    Add-Line $sb 'FreqMin=130'
    Add-Line $sb 'FreqMax=16500'
    
    # [参数标注] Sensitivity: 输入信号灵敏度增益 (dB)。
    # 提高此值可放大低音量时的频谱振幅，过高可能导致大音量时频繁满格。
    Add-Line $sb 'Sensitivity=32'
    
    Add-Line $sb ("Bands=" + ($Bands + 1))
    Add-Line $sb ''

    # ---- Left Channel Measures ----
    if ($hasL) {
        Add-Line $sb '; ---- Left Channel Measures ----'
        # [参数标注] AverageSize: 子频段数据的移动平均采样帧数。
        # 对近 N 帧数据取平均值，防止高频采样引起的频谱柱剧烈抖动/闪烁。
        for ($i = 1; $i -le $Bands; $i++) {
            $id = '{0:D2}' -f $i
            Add-Line $sb "[mL$id]"
            Add-Line $sb 'Measure=Plugin'
            Add-Line $sb 'Plugin=AudioLevel'
            Add-Line $sb 'Parent=MeasureAudio'
            Add-Line $sb 'Type=Band'
            Add-Line $sb 'Channel=L'
            Add-Line $sb "BandIdx=$i"
            Add-Line $sb 'AverageSize=6'
            Add-Line $sb ''
        }
    }

    # ---- Right Channel Measures ----
    if ($hasR) {
        Add-Line $sb '; ---- Right Channel Measures ----'
        for ($i = 1; $i -le $Bands; $i++) {
            $id = '{0:D2}' -f $i
            Add-Line $sb "[mR$id]"
            Add-Line $sb 'Measure=Plugin'
            Add-Line $sb 'Plugin=AudioLevel'
            Add-Line $sb 'Parent=MeasureAudio'
            Add-Line $sb 'Type=Band'
            Add-Line $sb 'Channel=R'
            Add-Line $sb "BandIdx=$i"
            Add-Line $sb 'AverageSize=6'
            Add-Line $sb ''
        }
    }

    # ---- Meter Styles ----
    Add-Line $sb '; ---------------- Meter Styles ----------------'
    Add-Line $sb '[StyleMain]'
    Add-Line $sb 'BarOrientation=Vertical'
    Add-Line $sb 'Y=5'
    Add-Line $sb "W=$BarW"
    Add-Line $sb "H=$H"
    Add-Line $sb 'BarColor=255,255,255'
    Add-Line $sb ''

    if ($Mode -eq 'Default') {
        Add-Line $sb '[StyleRefl]'
        Add-Line $sb 'BarOrientation=Vertical'
        Add-Line $sb 'Y=208'
        Add-Line $sb "W=$BarW"
        Add-Line $sb "H=$RefH"
        Add-Line $sb 'Flip=1'
        Add-Line $sb 'BarColor=255,255,255,50'
        Add-Line $sb ''
    }

    # ---- Main Bars ----
    Add-Line $sb '; ---------------- Main Bars ----------------'
    if ($hasL) {
        for ($i = 1; $i -le $Bands; $i++) {
            $id = '{0:D2}' -f $i
            $x = $l0 - ($i - 1) * $Step
            Add-Line $sb "[BandL$id]"
            Add-Line $sb 'Meter=Bar'
            Add-Line $sb 'MeterStyle=StyleMain'
            Add-Line $sb "MeasureName=mL$id"
            Add-Line $sb "X=$x"
            Add-Line $sb ''
        }
    }
    if ($hasR) {
        for ($i = 1; $i -le $Bands; $i++) {
            $id = '{0:D2}' -f $i
            $x = $r0 + ($i - 1) * $Step
            Add-Line $sb "[BandR$id]"
            Add-Line $sb 'Meter=Bar'
            Add-Line $sb 'MeterStyle=StyleMain'
            Add-Line $sb "MeasureName=mR$id"
            Add-Line $sb "X=$x"
            Add-Line $sb ''
        }
    }

    # ---- Reflections ----
    if ($Mode -eq 'Default') {
        Add-Line $sb '; ---------------- Reflections ----------------'
        if ($hasL) {
            for ($i = 1; $i -le $Bands; $i++) {
                $id = '{0:D2}' -f $i
                $x = $l0 - ($i - 1) * $Step
                Add-Line $sb "[ReflL$id]"
                Add-Line $sb 'Meter=Bar'
                Add-Line $sb 'MeterStyle=StyleRefl'
                Add-Line $sb 'Hidden=#HideVizReflection#'
                Add-Line $sb "MeasureName=mL$id"
                Add-Line $sb "X=$x"
                Add-Line $sb ''
            }
        }
        if ($hasR) {
            for ($i = 1; $i -le $Bands; $i++) {
                $id = '{0:D2}' -f $i
                $x = $r0 + ($i - 1) * $Step
                Add-Line $sb "[ReflR$id]"
                Add-Line $sb 'Meter=Bar'
                Add-Line $sb 'MeterStyle=StyleRefl'
                Add-Line $sb 'Hidden=#HideVizReflection#'
                Add-Line $sb "MeasureName=mR$id"
                Add-Line $sb "X=$x"
                Add-Line $sb ''
            }
        }
    }

    # ---- Baseline ----
    Add-Line $sb '; ---------------- Baseline ----------------'
    # 性能优化：去除了不必要的 DynamicVariables=1
    if ($hasL) {
        Add-Line $sb '[LineL]'
        Add-Line $sb 'Meter=Image'
        Add-Line $sb 'ImageName=#@#Images\Line.png'
        Add-Line $sb 'X=0'
        Add-Line $sb 'Y=206'
        Add-Line $sb 'W=850'
        Add-Line $sb 'H=1'
        Add-Line $sb 'ImageTint=#LineColor#'
        Add-Line $sb ''
    }
    if ($hasR) {
        Add-Line $sb '[LineR]'
        Add-Line $sb 'Meter=Image'
        Add-Line $sb 'ImageName=#@#Images\Line.png'
        Add-Line $sb 'X=720'
        Add-Line $sb 'Y=206'
        Add-Line $sb 'W=850'
        Add-Line $sb 'H=1'
        Add-Line $sb 'ImageTint=#LineColor#'
        Add-Line $sb ''
    }

    # UTF-8 无 BOM 输出
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [IO.File]::WriteAllText($OutPath, $sb.ToString(), $utf8NoBom)
    Write-Output ("Generated: $OutPath (" + (Get-Item $OutPath).Length + " bytes)")
}

# 批量生成 4 个版本
Generate-VisualizerVariant -Mode 'Default'    -OutPath (Join-Path $vizDir 'Visualizer.ini')
Generate-VisualizerVariant -Mode 'NoRefl'     -OutPath (Join-Path $vizDir 'Visualizer_NoRefl.ini')
Generate-VisualizerVariant -Mode 'LeftOnly'   -OutPath (Join-Path $vizDirL 'Visualizer_Left.ini')
Generate-VisualizerVariant -Mode 'RightOnly'  -OutPath (Join-Path $vizDirR 'Visualizer_Right.ini')