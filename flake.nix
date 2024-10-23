{
  description = "Home Manager configuration of Pete Newman";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { home-manager, nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      username = "peter.newman";
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            {
              home = {
                # Update the state version as needed.
                # See the changelog here:
                # https://nix-community.github.io/home-manager/release-notes.html
                stateVersion = "24.05";
              };
            }
          ];
        };
    };
}
