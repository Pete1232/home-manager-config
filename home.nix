{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "peten";
  home.homeDirectory = "/home/peten";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
    pkgs.mill
    pkgs.scala
  ];

  nixpkgs.overlays = [ (final: prev: { jre = prev.jdk11; }) ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
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

  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  programs.sbt = {
    enable = true;
    package = pkgs.sbt;
    plugins = [
      {
        org = "net.virtual-void";
        artifact = "sbt-dependency-graph";
        version = "0.10.0-RC1";
      }
      {
        org = "com.timushev.sbt";
        artifact = "sbt-updates";
        version = "0.5.1";
      }
    ];
  };

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
      disneystreaming.smithy
      yzhang.markdown-all-in-one
    ];
  };
}
