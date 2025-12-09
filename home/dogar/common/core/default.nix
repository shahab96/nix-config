{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}: {
  imports = lib.flatten [
    (map lib.custom.relativeToRoot ["modules/common" "modules/home-manager"])
  ];

  inherit hostSpec;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "25.05";
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "zsh";
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
