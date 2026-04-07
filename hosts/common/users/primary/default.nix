{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  hostSpec = config.hostSpec;
  pubKeys = lib.filesystem.listFilesRecursive ./keys;
in
{
  users = {
    mutableUsers = false;
    users.${hostSpec.username} = {
      # Only do this if you have already configured zsh in home manager
      ignoreShellProgramCheck = true;

      name = hostSpec.username;
      shell = pkgs.zsh;
      home = hostSpec.home;
      isNormalUser = true;
      hashedPassword = "$y$j9T$pvjyL7hL5x2VBarGNTnMl1$mLA2UsWTbfp8Hgp/ug5l8224thi..Mo8.p7ME.tDZ.4";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "libvirtd"
        "docker"
      ];

      # Read all keys in ./keys and add them to authorizedKeys.
      openssh.authorizedKeys.keys = lib.lists.forEach pubKeys (key: builtins.readFile key);

      packages = with pkgs; [ libnotify ];
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users.${hostSpec.username}.imports = lib.flatten [
      (
        { config, ... }:
        import (lib.custom.relativeToRoot "home/${hostSpec.username}/${hostSpec.hostName}.nix") {
          inherit
            pkgs
            inputs
            config
            lib
            hostSpec
            ;
        }
      )
    ];
  };
}
