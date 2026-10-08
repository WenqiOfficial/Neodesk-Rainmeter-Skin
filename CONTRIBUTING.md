# Contributing

Thanks for your interest in NeoDesk.

## Development setup

1. Install Rainmeter 4.5 or newer.
2. Clone this repository.
3. Open the repository in your preferred editor.
4. Run `.\build.ps1` to create a local package.

## Code style

- Keep Rainmeter `.ini` files readable and use section comments only where they clarify structure.
- Keep Lua scripts small and focused.
- Use UTF-16 LE for the main skin `.ini` files that already use it.
- Keep PowerShell scripts compatible with Windows PowerShell 5.1 and PowerShell 7.

## Pull requests

1. Create a feature branch.
2. Make your changes.
3. Run `.\build.ps1`.
4. Confirm the generated zip contains the expected skin files.
5. Submit a pull request describing the change and the reason.

For larger changes, please open an issue first.
