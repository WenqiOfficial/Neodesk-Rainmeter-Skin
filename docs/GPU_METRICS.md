# GPU metrics

NeoDesk uses the built-in Rainmeter `UsageMonitor` plugin and the Windows `GPU Engine` performance counter.

## Sample format

```text
pid_42164_luid_0x00000000_0x00015568_phys_0_eng_0_engtype_3D
pid_42164_luid_0x00000000_0x00015568_phys_0_eng_3_engtype_Copy
```

Each sample is already split by process ID and engine instance.

## Aggregation

`GpuSplit.lua` groups samples by:

```text
adapter LUID + engine type
```

For each adapter, it sums all process samples for `3D` and `Copy`, then uses the larger total as that adapter's usage.

This follows the Windows Task Manager semantic:

```text
adapter usage = max over engine types of sum over processes
```

## Progress bar

The raw totals are not truncated at 100%. If the combined Intel and NVIDIA totals exceed 100%, the progress bar is scaled proportionally so the two segments always fit the full track.

Example:

```text
Intel 130%, NVIDIA 20%
```

The bar is drawn using the ratio `130:20`, so Intel occupies roughly 86.7% of the track and NVIDIA occupies the remaining 13.3%.

## Adapter identification

`Settings.inc` pins the two adapter LUIDs used by the skin:

```ini
GpuLuid0Override=0x00000000_0x000143A3
GpuLuid1Override=0x00000000_0x00015568
```

These values are specific to the reference machine. If your GPU order is reversed or changes, update `Settings.inc` rather than the Lua script.
