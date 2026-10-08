# NeoDesk Rainmeter Skin

NeoDesk is a compact Rainmeter suite with a clock, greeting card, network monitor, system monitor, and a 121-band audio visualizer.

## Features

- **System** — CPU usage and live frequency, RAM physical/committed usage, and dual-GPU usage with a shared progress bar.
- **Clock** — large centered time and date card.
- **Network** — SSID, signal quality, local IP, public IP, and live transfer rates.
- **Greeting** — time-based greeting, Windows account avatar, and random sentence.
- **Visualizer** — 121-band audio visualizer with optional reflection and left/right variants.

## Requirements

- Windows 10 1709 or newer, Windows 11 recommended.
- Rainmeter 4.5 or newer.
- The bundled MiSans fonts and Rainmeter plugins; no third-party Rainmeter plugins are required.

## Install

1. Download the latest `NeoDesk_<version>.zip` from the [releases](releases) page.
2. Extract the `NeoDesk` folder into your Rainmeter `Skins` directory.
3. Open Rainmeter, refresh all skins, and enable the layouts you want.

Detailed instructions are in [docs/INSTALL.md](docs/INSTALL.md).

## Build locally

```powershell
.\build.ps1
```

By default this creates a development build named like `dev+202610082045`.

To build a specific release version:

```powershell
.\build.ps1 -Version 1.2.0
```

Build output is written to:

- `dist\NeoDesk_<version>.zip`
- `dist\NeoDesk_<version>.zip.sha256`

See [docs/BUILD.md](docs/BUILD.md) for more details.

## Versioning

- Development builds use `dev+yyyyMMddHHmm`.
- Release builds use the Git tag name, such as `1.2.0` from `v1.2.0`.
- A manual `-Version` input always wins.

See [docs/VERSIONING.md](docs/VERSIONING.md).

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

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## License

MIT. See [LICENSE](LICENSE).

## Credits

See [docs/CREDITS.md](docs/CREDITS.md).
