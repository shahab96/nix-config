{
  inputs,
  pkgs,
  lib,
  ...
}: let
  hostName = "aamil-3";
in {
  imports = lib.flatten [
    #
    # ========= Hardware =========
    #
    ./hardware-configuration.nix

    #
    # ========= Disk Layout =========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/aamil.nix")

    #
    # ========= Required Configs =========
    #
    (map lib.custom.relativeToRoot ["hosts/common/core"])

    #
    # ========= Services =========
    #
    (map
      (s: lib.custom.relativeToRoot "hosts/common/optional/services/${s}.nix") [
        "k3s"
        "openiscsi"
        "openssh"
      ])
  ];

  #
  # ========= Host specification =========
  #
  hostSpec = {
    hostName = hostName;
  };

  networking = {
    hostName = hostName;
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };

  nix = {
    settings = {
      require-sigs = false;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Fixes for longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  virtualisation.docker.logDriver = "json-file";

  security.sudo.extraRules = [
    {
      users = ["shahab"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  system.stateVersion = "25.05";
}
