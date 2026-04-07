{
  lib,
  config,
  device,
  withSwap,
  swapSize,
  label,
  ...
}:
{
  disko = {
    devices = {
      disk = {
        main = {
          inherit device;

          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              luks = {
                size = "100%";
                content = {
                  name = "crypted";
                  type = "luks";
                  passwordFile = "/tmp/secret.key";
                  settings = {
                    allowDiscards = true;
                    crypttabExtraOpts = [
                      "fido2-device=auto"
                      "token-timeout=10"
                    ];
                  };
                  content = {
                    type = "lvm_pv";
                    vg = "crypt_vg";
                  };
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        crypt_vg = {
          type = "lvm_vg";
          lvs = {
            swap = lib.mkIf withSwap {
              size = "${swapSize}G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            main = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  label
                  "-f"
                ];
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "subvol=root"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@persist" = {
                    mountpoint = config.hostSpec.persist;
                    mountOptions = [
                      "subvol=persist"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
