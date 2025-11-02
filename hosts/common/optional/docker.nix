{pkgs, ...}: {
  virtualisation = {
    docker = {
      enable = true;
      daemon = {
        settings = {
          features = {
            containerd-snapshotter = true;
          };
        };
      };
    };

    containers = {registries = {search = ["docker.io"];};};

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
  ];
}
