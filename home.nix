{ config, pkgs, lib, nixpkgs-unstable, nurpkgs, ... }:

let
  sbtConfigPath = ".sbt/1.0";
  awsp-script = import ./programs/aws/awsp.nix;
in {
  imports = [ ./programs/aws ];

  home = {
    username = "peten";
    homeDirectory = "/home/peten";
    packages = [ pkgs.coursier pkgs.mill pkgs.nixfmt pkgs.scala pkgs.cachix pkgs.coursier ];
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

  programs.firefox = {
    enable = false;
    package = pkgs.firefox;
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
      version = "0.6.2";
    }];
  };

  home.file."${sbtConfigPath}/global.sbt".text = ''
    dependencyUpdatesFilter -= moduleFilter(organization = "org.scala-lang", name = "scala-library")
  '';

  home.file."${sbtConfigPath}/plugins/built-in.sbt".text = ''
    addDependencyTreePlugin
  '';

  programs.vscode = {
    enable = false;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions;
      [
        arrterian.nix-env-selector
        bbenoist.nix
        davidanson.vscode-markdownlint
        disneystreaming.smithy
        esbenp.prettier-vscode
        github.vscode-pull-request-github
        hashicorp.terraform
        redhat.java
        redhat.vscode-yaml
        scala-lang.scala
        scalameta.metals
        yzhang.markdown-all-in-one
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "smithy-playground";
          publisher = "kubukoz";
          version = "0.2.4";
          sha256 =
            "7952c1711b860ed76da29a8964af91fb303ae1338b716051344e5d5012b08a3d";
        }
        {
          name = "plantuml";
          publisher = "jebbs";
          version = "2.17.4";
          sha256 =
            "7e7cfab9b07bde2eeb25cbfea5a632355d6be1c45ebb214f8e03ccd073b8d2e8";
        }
      ];
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    # need to flip this off and delete conflicting files when updating
    # https://github.com/NixOS/nix/issues/5445
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "aws" "git" "docker" "docker-compose" "k" ];
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
