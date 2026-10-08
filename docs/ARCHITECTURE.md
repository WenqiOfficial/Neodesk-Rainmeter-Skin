# Architecture

NeoDesk is a single Rainmeter skin suite. The repository is organized so the skin itself stays directly usable and the build system remains separate.

## Repository layout

```text
NeoDesk/
  @Resources/
    Fonts/        Bundled MiSans fonts.
    Images/       Shared images.
    Language/     English and Chinese label files.
    Scripts/      Runtime Lua scripts.
    Text/         Random sentence source for the greeting skin.
    Theme/        Shared settings, styles, and version metadata.
  Clock/          Time and date skin.
  Greeting/        Greeting and avatar skin.
  Network/         Network status skin.
  System/          CPU, RAM, and GPU skin.
  Visualizer/       Main audio visualizer and no-reflection variant.
  Visualizer_L/     Left-channel visualizer.
  Visualizer_R/     Right-channel visualizer.
```

## Shared resources

`@Resources\Theme\Styles.inc` contains the shared design tokens and meter styles. `@Resources\Theme\Settings.inc` contains user-adjustable options such as language, reflection behavior, GPU labels, and GPU LUID overrides. `@Resources\Theme\Version.inc` stores the canonical skin metadata and the build-injected version.

`@Resources\Language\English.inc` and `Chinese.inc` provide display labels. The active language is selected by the `Language` variable in `Settings.inc`.

## Skin logic

Each skin is a standalone `.ini` file. Shared options are pulled in through `@include` directives. The system skin additionally loads `GpuSplit.lua`, which reads `UsageMonitor` GPU Engine samples and computes per-adapter usage.

The visualizer skins are generated variants. The main, no-reflection, left, and right versions all share the same audio engine and design vocabulary.

The visualizer generator lives in `scripts\visualizer.ps1`. It is a development tool and is not included in the runtime skin package.

Runtime skin files use UTF-16 LE with BOM. This is required by Rainmeter for Unicode-safe `.ini`, `.inc`, text, and Lua files.

## Build system

`build.ps1` copies the skin to a staging directory, injects the version, copies the project documents into the package, and creates a zip with a SHA-256 checksum.

GitHub Actions uses the same build script on Windows. A push to the main branch creates a development artifact. A tag push creates a release package.
