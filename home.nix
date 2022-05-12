{ config, pkgs, ... }:

{
  home.username = "peten";
  home.homeDirectory = "/home/peten";

  home.packages = [
    pkgs.mill
    pkgs.scala
  ];

  nixpkgs.overlays = [ (final: prev: { jre = prev.jdk11; }) ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    delta.enable = true;
    extraConfig = {
      core = {
        autocrlf = "input";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = "false";
      };
    };
    ignores = [".idea/" ".bsp/" ".vscode/" ".bloop/" "metals.sbt" "*.code-workspace" ".metals" "./ammonite/" ".terraform/"];
    userEmail = "peter.newman@disneystreaming.com";
    userName = "petenewman";
  };

  programs.home-manager = {
    enable = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  programs.jq = {
    enable = true;
    package = pkgs.jq;
  };

  programs.sbt = {
    enable = true;
    package = pkgs.sbt;
    # dependency tree is enabled via another mechanism now that isn't compatible
    plugins = [
      {
        org = "com.timushev.sbt";
        artifact = "sbt-updates";
        version = "0.6.2";
      }
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    # need to flip this off and delete conflicting files when updating
    # https://github.com/NixOS/nix/issues/5445
    enableCompletion = true;
    initExtra = "
export JAVA_HOME=/home/peten/.nix-profile/bin/java
if [ -e /home/peten/.nix-profile/etc/profile.d/nix.sh ]; then . /home/peten/.nix-profile/etc/profile.d/nix.sh; fi
";
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "docker" "docker-compose" "k"];
      theme = "simple";
      custom = "$HOME/.oh-my-zsh/custom";
    };
  };
}
