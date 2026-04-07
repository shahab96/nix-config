{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    eza
    ripgrep
    rm-improved
    dust
    xcp
    nh
    zoxide
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      eval "$(zoxide init zsh)"
      export PATH=/home/shahab/.opencode/bin:$PATH
    '';

    shellAliases = {
      ".." = "cd ..";
      ls = "exa";
      vim = "nvim";
      grep = "rg";
      du = "dust";
      rm = "rip";
      cp = "xcp";
      uo = "nh os switch ~/git/nix-config";
      k = "kubectl";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
