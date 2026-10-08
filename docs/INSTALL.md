# Install

## Requirements

- Windows 10 1709 or newer.
- Rainmeter 4.5 or newer.
- No third-party Rainmeter plugins are required.

## Install Rainmeter

Download and install Rainmeter from:

```text
https://www.rainmeter.net/
```

## Install NeoDesk

Download `NeoDesk_<version>.zip`, then extract the `NeoDesk` folder into your Rainmeter `Skins` directory.

A typical path is:

```text
C:\Users\<user>\Documents\Rainmeter\Skins\
```

After extraction you should have:

```text
...\Rainmeter\Skins\NeoDesk\
```

## Enable the skins

Right-click the Rainmeter tray icon and choose **Refresh all**.

Open the Rainmeter manager and enable the layouts you want:

- `NeoDesk\Clock`
- `NeoDesk\Greeting`
- `NeoDesk\Network`
- `NeoDesk\System`
- `NeoDesk\Visualizer`
- `NeoDesk\Visualizer_L`
- `NeoDesk\Visualizer_R`

## Configure

User settings live in:

```text
NeoDesk\@Resources\Theme\Settings.inc
```

### Language

```ini
Language=Chinese
```

Supported values are `Chinese` and `English`.

### Visualizer reflection

```ini
HideVizReflection=0
```

- `0` shows the reflection.
- `1` hides the reflection.

### GPU names

```ini
GpuIntelName=Intel Iris Xe
GpuNvidiaName=Nvidia MX450
```

### GPU LUIDs

```ini
GpuLuid0Override=0x00000000_0x000143A3
GpuLuid1Override=0x00000000_0x00015568
```

The first value maps to the Intel slot, and the second maps to the NVIDIA slot.
If your GPU values are displayed in the wrong order, swap these two values.

Save the file and refresh Rainmeter.
