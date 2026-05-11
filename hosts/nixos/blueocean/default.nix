{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========= Hardware =========
    #
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.lenovo-legion-16ithg6

    #
    # ========= Disk Layout =========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/blueocean.nix")
    {
      _module.args = {
        primary = "/dev/nvme0n1";
        nix = "/dev/nvme1n1";
        withSwap = true;
        swapSize = "4";
        label = "nixos";
      };
    }

    #
    # ========= Required Configs =========
    #
    (map lib.custom.relativeToRoot [ "hosts/common/core" ])

    #
    # ========= Optional Configs =========
    #
    (map (c: lib.custom.relativeToRoot "hosts/common/optional/${c}.nix") [
      "1password"
      "claude-code"
      "dconf"
      "docker"
      "hyprland"
      "nodejs"
      "nix-ld"
      "thunderbird"
      "secure-boot"
      "slack"
      "yubikey"
      "zoom"
    ])

    #
    # ========= Optional Services =========
    #
    (map (s: lib.custom.relativeToRoot "hosts/common/optional/services/${s}.nix") [
      "audio"
      "bluetooth"
      "firmware"
      "greetd"
      "openssh"
      "printing"
      "smart-card"
      "vpn"
    ])
  ];

  #
  # ========= Host specification =========
  #
  hostSpec = {
    hostName = "blueocean";
    username = "dogar";
    handle = "shadogar";
    email = {
      user = "shahab.dogar@blueocean.ai";
    };
    useYubikey = lib.mkForce true;
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    loader = {
      # Set this to true on first install. This must be false for secure boot.
      systemd-boot = {
        enable = lib.mkForce (!config.hostSpec.secureBoot);
        configurationLimit = config.hostSpec.bootHistoryLimit;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  security.rtkit.enable = true;
  system.stateVersion = "25.05";
}
