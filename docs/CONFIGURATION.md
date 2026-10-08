# Configuration

All user-adjustable settings live in:

```text
NeoDesk\@Resources\Theme\Settings.inc
```

## Language

```ini
Language=Chinese
```

Available values:

- `Chinese`
- `English`

## Visualizer reflection

```ini
HideVizReflection=0
```

Values:

- `0` — show reflection.
- `1` — hide reflection.

## GPU labels

```ini
GpuIntelName=Intel Iris Xe
GpuNvidiaName=Nvidia MX450
```

These labels are displayed on the System skin.

## GPU adapter LUIDs

```ini
GpuLuid0Override=0x00000000_0x000143A3
GpuLuid1Override=0x00000000_0x00015568
```

The first value is the Intel slot, and the second is the NVIDIA slot.

If your two GPUs are displayed in the wrong order, swap these two values.
