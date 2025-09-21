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

## Maintenance

### Updating the Formula

When a new version of Traverse is released:

#### Automatic Update (via GitHub Action)
1. Go to [Actions](https://github.com/calltrace/homebrew-tap/actions)
2. Run "Update Formula" workflow
3. Enter the version number (e.g., `0.1.3`)
4. Review and merge the created PR

#### Manual Update
```bash
# Update formula with new SHA256 hashes
./scripts/update-formula.sh 0.1.3

# Test the updated formula
./scripts/test-formula.sh

# Commit and push
git add Formula/traverse.rb
git commit -m "Update formula for v0.1.3"
git push
```

### Testing

Test the formula locally:
```bash
./scripts/test-formula.sh
```

This will:
- Check formula syntax
- Test installation
- Verify all binaries work
- Run formula test block

### CI/CD

This repository includes GitHub Actions workflows:
- **test.yml** - Tests formula on every PR and push
- **update-formula.yml** - Updates formula when triggered (manually or from traverse releases)

### Repository Dispatch

The main traverse repository can trigger formula updates via repository dispatch:
```bash
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/calltrace/homebrew-tap/dispatches \
  -d '{"event_type":"traverse-release","client_payload":{"version":"0.1.3"}}'
```

## Scripts

- **scripts/update-formula.sh** - Updates formula with SHA256 hashes for a new version
- **scripts/test-formula.sh** - Tests formula installation and functionality

## License

MIT