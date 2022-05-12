# home-manager-config

[Installation instructions](https://nixos.wiki/wiki/Home_Manager)

[Find packages](https://search.nixos.org/packages)

[Options](https://nix-community.github.io/home-manager/options.html)

## Usage

```sh
flakeUri=<flake.nix uri>
home-manager switch --flake "$flakeUri#peten"
```

## Notes

### Java and SBT

- For work projects an overlay of Java 11 is needed. For perfonal projects this can be overriden with custom config.
- The dependency tree plugin is now built into SBT, but home-manager doesn't support that.
- `JAVA_HOME` needs to be explicitly added to the `initExtra`. Not sure why since I expected the Java program to do this.

### Nix

- The Nix install script needs to be an `initExtra`. Think this is because home-manager doesn't support profiles yet.

### ZSH

- Autosuggestions can error when being enabled. Just need to flip the setting off/on. See [this issue](https://github.com/NixOS/nix/issues/5445)
