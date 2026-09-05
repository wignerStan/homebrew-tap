# wignerStan Homebrew tap

Rolling source builds for the CLIProxyAPI model-catalog patch and its companion
key-policy plugin.

## Install

The patched host installs the same `cliproxyapi` executable as the upstream
formula, so stop and uninstall the upstream formula first after backing up its
configuration.

```sh
brew tap wignerStan/tap
brew install --HEAD wignerStan/tap/cliproxyapi-patched
brew install --HEAD wignerStan/tap/cpa-key-policy-catalog
```

The host configuration is installed at
`$(brew --prefix)/etc/cliproxyapi-patched.conf`. Set its plugin directory to the
path printed by:

```sh
brew --prefix wignerStan/tap/cpa-key-policy-catalog
```

Append `/libexec` to that path, enable `cpa-key-policy`, and configure its
`catalog_groups`. See the
[plugin example](https://github.com/wignerStan/cpa-plugin-key-policy/blob/feature/model-catalog-policy/config.example.yaml)
for the complete shape.

Start the patched service with:

```sh
brew services start wignerStan/tap/cliproxyapi-patched
```

## Update

Both formulas intentionally track maintained Git branches. Fetch and rebuild
their latest commits with:

```sh
brew update
brew upgrade --fetch-HEAD wignerStan/tap/cliproxyapi-patched
brew upgrade --fetch-HEAD wignerStan/tap/cpa-key-policy-catalog
brew services restart wignerStan/tap/cliproxyapi-patched
```

The CLIProxyAPI patch branch is rebased against upstream `main` each day. The
automation tests the patched SDK and builds the server before updating the
branch; a conflict or regression leaves the last working branch in place.
