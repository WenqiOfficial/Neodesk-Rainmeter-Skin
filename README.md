# NeoDesk Rainmeter Skin

[English](README.md) | [简体中文](README.zh-CN.md)

[![Release](https://img.shields.io/github/v/release/WenqiOfficial/Neodesk-Rainmeter-Skin?style=flat-square)](https://github.com/WenqiOfficial/Neodesk-Rainmeter-Skin/releases)
[![License](https://img.shields.io/github/license/WenqiOfficial/Neodesk-Rainmeter-Skin?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-blue?style=flat-square)](#)

NeoDesk is a compact Rainmeter suite for Windows. It combines a clock, greeting card, network monitor, system monitor, and a 121-band audio visualizer in a consistent dark-card design.

## Features

- **System** — CPU usage and live frequency, RAM physical/committed usage, and dual-GPU usage with a shared progress bar.
- **Clock** — large centered time and date card.
- **Network** — SSID, signal quality, local IP, public IP, and live transfer rates.
- **Greeting** — time-based greeting, Windows account avatar, and random sentence.
- **Visualizer** — 121-band audio visualizer with optional reflection and left/right variants.

## Requirements

- Windows 10 1709 or newer.
- Rainmeter 4.5 or newer.
- No third-party Rainmeter plugins are required.

## Install

1. Download the latest `NeoDesk_<version>.zip` from the [releases](https://github.com/WenqiOfficial/Neodesk-Rainmeter-Skin/releases) page.
2. Extract the `NeoDesk` folder into your Rainmeter `Skins` directory.
3. Refresh Rainmeter and enable the layouts you want.

Detailed instructions are in [docs/INSTALL.md](docs/INSTALL.md).

## Build

```powershell
.\build.ps1
```

This creates a development package named like `NeoDesk_dev+202610082045.zip`.

To build a release package:

```powershell
.\build.ps1 -Release 1.2.0
```

Output is written to:

- `dist\NeoDesk_<version>.zip`
- `dist\NeoDesk_<version>.zip.sha256`

See [docs/BUILD.md](docs/BUILD.md).

## Release

Pushing a tag such as `v1.2.0` triggers the release workflow. GitHub Actions will:

1. Build the package.
2. Generate release notes from `CHANGELOG.md`.
3. Publish a GitHub release with the zip and checksum.

## Project structure

```text
NeoDesk/
  @Resources/
    Fonts/
    Images/
    Language/
    Scripts/
    Text/
    Theme/
  Clock/
  Greeting/
  Network/
  System/
  Visualizer/
  Visualizer_L/
  Visualizer_R/
```

More details are in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Documentation

- [Installation and configuration](docs/INSTALL.md)
- [Build and release](docs/BUILD.md)
- [Architecture](docs/ARCHITECTURE.md)
- [GPU metrics](docs/GPU_METRICS.md)
- [Credits](docs/CREDITS.md)

## License

MIT. See [LICENSE](LICENSE).
