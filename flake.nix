{
  description = "Home Manager configuration of Pete Newman";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nurpkgs.url = "github:nix-community/NUR";
  };

  outputs = { home-manager, nixpkgs-unstable, nurpkgs, ... }:
    let
      system = "aarch64-darwin";
      username = "peter.newman";
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          # Specify the path to your home configuration here
          configuration = import ./home.nix;

          extraSpecialArgs = {
            nixpkgs-unstable = nixpkgs-unstable;
            nurpkgs = nurpkgs;
          };

          inherit system username;
          homeDirectory = "/Users/${username}";
          # Update the state version as needed.
          # See the changelog here:
          # https://nix-community.github.io/home-manager/release-notes.html
          stateVersion = "22.05";
        };
    };
}
