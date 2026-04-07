{
  inputs,
  pkgs,
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
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    #
    # ======== Secure Boot =========
    #
    inputs.lanzaboote.nixosModules.lanzaboote

    #
    # ========= Disk Layout =========
    #
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/rihla.nix")
    {
      _module.args = {
        device = "/dev/nvme0n1";
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
      "hoppscotch"
      "hyprland"
      "nix-ld"
      "obs"
      "secure-boot"
      "yubikey"
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

    #
    # ========= Specialisations ========
    #
    # (map
    #   (s: lib.custom.relativeToRoot "hosts/common/specialisations/${s}.nix") [
    #     "gaming"
    #   ])
  ];

  #
  # ========= Host specification =========
  #
  hostSpec = {
    hostName = "rihla";
    useYubikey = lib.mkForce true;
    secureBoot = false;
    persist = "/persist";
    impermanance = false;
    username = "shahab";
    handle = "shahab96";
    email = {
      user = "shahab@dogar.dev";
    };
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

    initrd.postResumeCommands = lib.mkIf config.hostSpec.impermanance (
      lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/crypt_vg/root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      ''
    );

    lanzaboote = {
      enable = config.hostSpec.secureBoot;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils
    bc
  ];

  system.stateVersion = "25.05";
}
