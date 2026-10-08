# Release process

## 1. Update the changelog

Add a new section to `CHANGELOG.md` for the release version.

## 2. Commit the release changes

```powershell
git switch main
git pull
git add .
git commit -m "Prepare release 1.2.0"
git push
```

## 3. Tag the release

```powershell
git tag v1.2.0
git push origin v1.2.0
```

## 4. GitHub Actions

The tag push triggers the release workflow.

The workflow will:

1. Resolve `v1.2.0` to `1.2.0`.
2. Build the skin package.
3. Create a GitHub release.
4. Attach the zip and checksum files.
