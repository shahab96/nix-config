{lib, ...}: {
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
      "nvim"
      "starship"
      "tmux"
      "zsh"
    ])
  ];

  home = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
