# Build

## Local build

### Development build

```powershell
.\build.ps1
```

This generates a development version such as `dev+202610082045`.

### Release build

```powershell
.\build.ps1 -Release 1.2.0
```

This generates `NeoDesk_1.2.0.zip`.

The output is written to:

```text
dist\NeoDesk_<version>.zip
dist\NeoDesk_<version>.zip.sha256
```

## What the build does

1. Resolves the version.
2. Copies `NeoDesk` into a staging directory.
3. Copies the bilingual README, `LICENSE`, `CHANGELOG.md`, and the `docs` folder into the package.
4. Writes the version into `@Resources\Theme\Version.inc`.
5. Writes the version into each skin's `[Metadata] Version=` field.
6. Creates the zip package.
7. Creates the SHA-256 checksum file.

The build does not modify the source files.

## Versioning

- Development builds use `dev+yyyyMMddHHmm`.
- Local release builds use the value passed to `-Release`.
- GitHub release builds use the tag name, with the leading `v` removed.

## Continuous integration

### Build workflow

`build.yml` runs on pushes to `main` and pull requests. It builds a development package and uploads it as an artifact.

### Release workflow

`release.yml` runs only when a tag matching `v*` is pushed.

```powershell
git tag v1.2.0
git push origin v1.2.0
```

The workflow will:

1. Resolve `v1.2.0` to `1.2.0`.
2. Build the skin package.
3. Generate release notes from `CHANGELOG.md`.
4. Create a GitHub release.
5. Attach the zip and checksum files.

Before tagging a release, add a matching section to `CHANGELOG.md`.
