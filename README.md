# Homebrew Tap for Calltrace Tools

This tap contains Homebrew formulae for Calltrace tools.

## Installation

```bash
brew tap calltrace/tap
brew install traverse
```

## Available Formulae

### Traverse

Solidity code analysis, visualization, and test generation tools.

```bash
brew install traverse
```

This will install the following tools:
- `sol2cg` - Generate call graphs from Solidity
- `sol2test` - Generate tests from Solidity  
- `sol2bnd` - Generate bindings from Solidity
- `sol-storage-analyzer` - Analyze Solidity storage layouts
- `storage-trace` - Trace storage operations

## Direct Installation

You can also install directly without tapping:

```bash
brew install calltrace/tap/traverse
```

## Development

To update formulae after a new release:

1. Update the version number in the formula
2. Update the SHA256 checksums for each platform
3. Commit and push changes

## License

MIT