{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    gh
    dbeaver-bin
    cloudflare-warp
    protonmail-desktop
    protonvpn-gui
    kubectl
    k9s
    postgresql_17
    kitty
    waybar
    obsidian
    yq
    jq
  ];
}
