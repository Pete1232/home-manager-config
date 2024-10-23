{ config, pkgs, lib, nixpkgs-unstable, nurpkgs, ... }:

let sbtConfigPath = ".sbt";
in {

  home = {
    username = "peter.newman";
    homeDirectory = "/Users/peter.newman";
    packages = [
      pkgs.awscli2
      pkgs.coursier
      pkgs.mill
      pkgs.nixfmt
      pkgs.scala
      pkgs.cachix
      pkgs.coursier
      pkgs.ammonite
    ];
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
    package = pkgs.jdk21;
  };

  programs.jq = {
    enable = true;
    package = pkgs.jq;
  };

  programs.sbt = {
    enable = true;
    package = pkgs.sbt;
    baseUserConfigPath = sbtConfigPath;
    plugins = [{
      org = "com.timushev.sbt";
      artifact = "sbt-updates";
      version = "0.6.4";
    }];
  };

  home.file."${sbtConfigPath}/1.0/global.sbt".text = ''
    dependencyUpdatesFilter -= moduleFilter(organization = "org.scala-lang", name = "scala-library")
  '';

  home.file."${sbtConfigPath}/1.0/plugins/built-in.sbt".text = ''
    addDependencyTreePlugin
  '';

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    # may need to flip this off and delete conflicting files when updating
    # https://github.com/NixOS/nix/issues/5445
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "git" "docker" "docker-compose" ];
      theme = "robbyrussell";
      custom = "$HOME/.oh-my-zsh/custom";
    };
    shellAliases = {
      # work aliases
      devxQA = ''
        devx cloud aws-login -r arn:aws:iam::789659335040:role/bamazon-TeamMercury --session-duration 3600 && eval "$(aws configure export-credentials --profile HULU_SSO --format env)"'';
      devxProd = ''
        devx cloud aws-login -r arn:aws:iam::141988508569:role/bamazon-TeamMercuryLimitedAccess --session-duration 3600 && eval "$(aws configure export-credentials --profile HULU_SSO --format env)"'';
    };
    initExtra = ''
      export PATH="$PATH:$HOME/.local/share/coursier/bin"
    '';
  };
}
