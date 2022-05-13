{
  description = "Home Manager configuration of Pete Newman";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; 
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nurpkgs.url = github:nix-community/NUR;
  };

  outputs = { home-manager, nixpkgs-unstable, nurpkgs, ... }:
    let
      system = "x86_64-linux";
      username = "peten";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./home.nix;

        extraSpecialArgs = {
          nixpkgs-unstable = nixpkgs-unstable;
          nurpkgs = nurpkgs;
        };

        inherit system username;
        homeDirectory = "/home/${username}";
        # Update the state version as needed.
        # See the changelog here:
        # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
        stateVersion = "21.11";
      };
    };
}
