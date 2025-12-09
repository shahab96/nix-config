{config, lib, ...}: {
  imports = lib.flatten [
    #
    # ========== Required Configs ==========
    #
    ./common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    (map (config: "${builtins.toString ./.}/common/optional/${config}.nix") [
      "btop"
      "direnv"
      "firefox"
      "fonts"
      "ghostty"
      "git"
      "hyprland"
      "kitty"
      "misc-packages"
      "nvim"
      "ssh"
      "starship"
      "tmux"
      "uv"
      "zsh"
    ])
  ];

  services.yubikey-touch-detector.enable = true;

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
    };
    file.".npmrc".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/git/nix-config/dotfiles/npm/.npmrc";
  };
}
