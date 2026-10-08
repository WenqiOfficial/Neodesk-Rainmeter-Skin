# Build

## Prerequisites

- Windows PowerShell 5.1 or PowerShell 7.
- No additional tools are required.

## Build a development package

```powershell
.\build.ps1
```

This creates:

```text
dist\NeoDesk_dev+202610082045.zip
dist\NeoDesk_dev+202610082045.zip.sha256
```

The timestamp is generated at build time using `yyyyMMddHHmm`.

## Build a specific version

```powershell
.\build.ps1 -Version 1.2.0
```

You can also pass a `v` prefix:

```powershell
.\build.ps1 -Version v1.2.0
```

Both commands produce `NeoDesk_1.2.0.zip`.

## What the build does

1. Resolves the version.
2. Copies `NeoDesk` to `build\NeoDesk`.
3. Copies the bilingual README, `LICENSE`, `CHANGELOG.md`, and the `docs` folder into the skin folder.
4. Writes the version into `@Resources\Theme\Version.inc`.
5. Writes the version into each skin's `[Metadata] Version=` field.
6. Creates the zip package.
7. Creates a SHA-256 checksum file.

The build does not modify the source files.

## Continuous integration

- Pushes to `main` build a development artifact.
- Pushes of `v*` tags build a release and publish it to GitHub Releases.

The workflows are stored under `.github\workflows`.
