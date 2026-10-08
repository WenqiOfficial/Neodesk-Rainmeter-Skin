# Versioning

NeoDesk uses a build-time version string.

## Development builds

If no version is provided and the build is not started from a tag, the build script generates:

```text
dev+yyyyMMddHHmm
```

Example:

```text
dev+202610082045
```

## Release builds

When GitHub Actions runs for a tag such as:

```text
v1.2.0
```

the build version becomes:

```text
1.2.0
```

The `v` prefix is optional and stripped automatically.

## Manual version override

You can always pass a version explicitly:

```powershell
.\build.ps1 -Version 1.2.0
```

Manual input takes precedence over the environment.

## Where the version is written

The build script injects the resolved version into:

- `NeoDesk\@Resources\Theme\Version.inc`
- The `[Metadata] Version=` field of every skin `.ini`

Source files keep `Version=dev` until a build replaces it in the staging copy.
