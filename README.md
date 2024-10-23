# home-manager-config

Runs against home-manager version `23.11``

[Installation instructions](https://nixos.wiki/wiki/Home_Manager)

[Find packages](https://search.nixos.org/packages)

[Options](https://nix-community.github.io/home-manager/options.xhtml)

[Update version](https://nix-community.github.io/home-manager/index.xhtml#sec-updating)

## Usage

```sh
flakeUri=<flake.nix uri>
home-manager switch --flake "$flakeUri#peter.newman"
```

To update

```sh
nix flake update
```

To format (don't forget to run home manager once first!)

```sh
nixfmt ./home.nix
```

## Notes

### Java and SBT

- For projects not using Nix an overlay of Java 11 is needed to make sure everything works. For personal projects this can be overriden with custom config.

### ZSH

- Autosuggestions can error when being enabled. Just need to flip the setting off/on. See [this issue](https://github.com/NixOS/nix/issues/5445)
