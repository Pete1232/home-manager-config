{
  home.packages = [
    pkgs.awscli2
  ];

  home.file.".aws/credentials".source =
    config.lib.file.mkOutOfStoreSymlink ~/secrets/.aws/credentials;
}
