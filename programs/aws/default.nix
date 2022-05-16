{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.awscli2
  ];
}
