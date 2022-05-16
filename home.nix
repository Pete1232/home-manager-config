{ config, pkgs, lib, nixpkgs-unstable, nurpkgs, ... }:

let
  sbtConfigPath = ".sbt/1.0";
in
{
  home = {
    username = "peten";
    homeDirectory = "/home/peten";
    packages = [
      pkgs.mill
      pkgs.scala
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (final: prev: { jre = prev.jdk11; })
      (final: prev: { unstable = nixpkgs-unstable.legacyPackages.${prev.system}; })
      nurpkgs.overlay
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
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
      user = {
        useConfigOnly = "true";
      };
    };
    ignores = [".idea/" ".bsp/" ".vscode/" ".bloop/" "metals.sbt" "*.code-workspace" ".metals" "./ammonite/" ".terraform/"];
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
    baseConfigPath = sbtConfigPath;
    plugins = [
      {
        org = "com.timushev.sbt";
        artifact = "sbt-updates";
        version = "0.6.2";
      }
    ];
  };

  home.file."${sbtConfigPath}/global.sbt".text = ''
    dependencyUpdatesFilter -= moduleFilter(organization = "org.scala-lang", name = "scala-library")
  '';

  home.file."${sbtConfigPath}/plugins/built-in.sbt".text = ''
    addDependencyTreePlugin
  '';

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      davidanson.vscode-markdownlint
      esbenp.prettier-vscode
      github.vscode-pull-request-github
      hashicorp.terraform
      redhat.java
      redhat.vscode-yaml
      scala-lang.scala
      scalameta.metals
      yzhang.markdown-all-in-one
    ] ++ (with pkgs.unstable.vscode-extensions; [
      disneystreaming.smithy
    ]);
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    # need to flip this off and delete conflicting files when updating
    # https://github.com/NixOS/nix/issues/5445
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "docker" "docker-compose" "k"];
      theme = "robbyrussell";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    initExtra = ''
      source $HOME/.config/nixpkgs/scripts/awsp_functions.sh
      alias awsall="_awsListProfile"
      alias awsp="_awsSwitchProfile"
      alias awswho="aws configure list"

      complete -W "$(cat $HOME/.aws/credentials | grep -Eo '\[.*\]' | tr -d '[]')" _awsSwitchProfile
      complete -W "$(cat $HOME/.aws/config | grep -Eo '\[.*\]' | tr -d '[]' | cut -d " " -f 2)" _awsSetProfile

      source $HOME/.config/nixpkgs/scripts/git-clean.sh
      alias git-clean="_gitClean"
    '';
  };
}
