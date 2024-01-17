{
  description = "Home Manager configuration of Pete Newman";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nurpkgs.url = "github:nix-community/NUR";
  };

  outputs = { home-manager, nixpkgs, nixpkgs-unstable, nurpkgs, ... }:
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
                stateVersion = "22.11";
              };
            }
          ];

          extraSpecialArgs = {
            nixpkgs-unstable = nixpkgs-unstable;
            nurpkgs = nurpkgs;
          };
        };
    };
}
