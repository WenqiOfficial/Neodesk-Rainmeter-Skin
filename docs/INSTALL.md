# Install

## 1. Install Rainmeter

Install Rainmeter 4.5 or newer:

```text
https://www.rainmeter.net/
```

## 2. Extract the skin

Download `NeoDesk_<version>.zip`, then extract the `NeoDesk` folder into your Rainmeter `Skins` directory.

A typical path is:

```text
C:\Users\<user>\Documents\Rainmeter\Skins\
```

After extraction you should have:

```text
...\Rainmeter\Skins\NeoDesk\
```

## 3. Refresh Rainmeter

Right-click the Rainmeter tray icon and choose **Refresh all**.

Open the Rainmeter manager and enable the layouts you want:

- `NeoDesk\Clock`
- `NeoDesk\Greeting`
- `NeoDesk\Network`
- `NeoDesk\System`
- `NeoDesk\Visualizer`
- `NeoDesk\Visualizer_L`
- `NeoDesk\Visualizer_R`

## 4. Configure

Open:

```text
NeoDesk\@Resources\Theme\Settings.inc
```

Common settings:

```ini
Language=Chinese
HideVizReflection=0
GpuIntelName=Intel Iris Xe
GpuNvidiaName=Nvidia MX450
GpuLuid0Override=0x00000000_0x000143A3
GpuLuid1Override=0x00000000_0x00015568
```

Save the file, then refresh Rainmeter.
