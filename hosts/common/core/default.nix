{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = lib.flatten [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    (map lib.custom.relativeToRoot [
      "modules/common"
      "hosts/common/users/primary"
    ])
  ];

  hostSpec = {
    userFullName = "Shahab Dogar";
    networking.ports.tcp.ssh = 22;
  };

  networking.hostName = config.hostSpec.hostName;

  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "bk";
  };

  #
  # ========= Overlays =========
  #
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  #
  # ========= Nix Settings =========
  #
  nix = {
    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [ "@wheel" ];

      substituters = [
        "https://hyprland.cachix.org"
        "https://nix.dogar.dev"
      ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # ========== Nix Helper ==========
  # Provide better build output and will also handle garbage collection in place of standard nix gc (garbace collection)
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 10";
    flake = "${config.hostSpec.home}/nix-config";
  };

  # ========= Sops =========
  environment.systemPackages = with pkgs; [ sops ];

  #
  # ========== Localization ==========
  #
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ur_PK";
    LC_IDENTIFICATION = "ur_PK";
    LC_MEASUREMENT = "ur_PK";
    LC_MONETARY = "ur_PK";
    LC_NAME = "ur_PK";
    LC_NUMERIC = "ur_PK";
    LC_PAPER = "ur_PK";
    LC_TELEPHONE = "ur_PK";
    LC_TIME = "ur_PK";
  };
  time.timeZone = lib.mkDefault "Asia/Karachi";
}
