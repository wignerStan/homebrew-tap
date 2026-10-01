# wignerStan Homebrew tap

CLIProxyAPI and its companion key-policy plugin.

## Install

The standard `cliproxyapi` formula builds the patched host from the
`wignerStan/cpa-plugin-key-policy` monorepo's `main` branch. The monorepo has
not published a versioned host release yet, so install the rolling formula with
`--HEAD`.

```sh
brew tap wignerStan/tap
brew install --HEAD wignerStan/tap/cliproxyapi
brew install --HEAD wignerStan/tap/cpa-key-policy-catalog
```

The default host configuration is installed at
`$(brew --prefix)/etc/cliproxyapi.conf`. Set its plugin directory to the path
printed by:

```sh
brew --prefix wignerStan/tap/cpa-key-policy-catalog
```

Append `/libexec` to that path, enable `cpa-key-policy`, and configure its
`catalog_groups`. See the
[plugin example](https://github.com/wignerStan/cpa-plugin-key-policy/blob/main/config.example.yaml)
for the complete shape.

Start the service with:

```sh
brew services start wignerStan/tap/cliproxyapi
```

## Update

Fetch the latest monorepo host and key-policy plugin sources with:

```sh
brew update
brew upgrade --fetch-HEAD wignerStan/tap/cliproxyapi
brew upgrade --fetch-HEAD wignerStan/tap/cpa-key-policy-catalog
brew services restart wignerStan/tap/cliproxyapi
```
