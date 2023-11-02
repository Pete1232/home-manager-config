{ config, pkgs, lib, nixpkgs-unstable, nurpkgs, ... }:

let
  sbtConfigPath = ".sbt/1.0";
  awsp-script = import ./programs/aws/awsp.nix;
in {
  imports = [ ./programs/aws ];

  home = {
    username = "peter.newman";
    homeDirectory = "/Users/peter.newman";
    packages = [
      pkgs.coursier
      pkgs.mill
      pkgs.nixfmt
      pkgs.scala
      pkgs.cachix
      pkgs.coursier
      pkgs.ammonite
    ];
    sessionVariables = { JAVA_HOME = "${pkgs.jdk}"; };
  };

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
    };
    overlays = [
      (final: prev: { jre = prev.jdk11; })
      (final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      })
      nurpkgs.overlay
    ];
  };

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
      core = { autocrlf = "input"; };
      init = { defaultBranch = "main"; };
      pull = { rebase = "false"; };
      user = { useConfigOnly = "true"; };
    };
    ignores = [
      ".ammonite"
      ".idea/"
      ".bsp/"
      ".vscode/"
      ".bloop/"
      "metals.sbt"
      "*.code-workspace"
      ".metals"
      "./ammonite/"
      ".terraform/"
      ".direnv"
    ];
  };

  programs.home-manager = { enable = true; };

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
    plugins = [{
      org = "com.timushev.sbt";
      artifact = "sbt-updates";
      version = "0.6.4";
    }];
  };

  home.file."${sbtConfigPath}/global.sbt".text = ''
    dependencyUpdatesFilter -= moduleFilter(organization = "org.scala-lang", name = "scala-library")
  '';

  home.file."${sbtConfigPath}/plugins/built-in.sbt".text = ''
    addDependencyTreePlugin
  '';

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    # need to flip this off and delete conflicting files when updating
    # https://github.com/NixOS/nix/issues/5445
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "git" "docker" "docker-compose" ];
      theme = "robbyrussell";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    shellAliases = {
      awsall = "_awsListProfile";
      awsp = "_awsSwitchProfile";
      awswho = "aws configure list";
    };
    initExtra = ''
      export PATH="$PATH:$HOME/.local/share/coursier/bin"
      source ${awsp-script}
      complete -W "$(cat $HOME/.aws/credentials | grep -Eo '\[.*\]' | tr -d '[]')" _awsSwitchProfile
      complete -W "$(cat $HOME/.aws/config | grep -Eo '\[.*\]' | tr -d '[]' | cut -d " " -f 2)" _awsSetProfile
    '';
  };
}
