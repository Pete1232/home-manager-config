# home-manager-config

[Installation instructions](https://nixos.wiki/wiki/Home_Manager)

[Find packages](https://search.nixos.org/packages)

[Options](https://nix-community.github.io/home-manager/options.html)

## Usage

```sh
flakeUri=<flake.nix uri>
home-manager switch --flake "$flakeUri#peten"
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
- The dependency tree plugin is now built into SBT, but home-manager doesn't support that. So it needs to be added in another plugin file.

### ZSH

- Autosuggestions can error when being enabled. Just need to flip the setting off/on. See [this issue](https://github.com/NixOS/nix/issues/5445)
