{...}: let
  onePassPath = "~/.1password/agent.sock";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = "IdentityAgent ${onePassPath}";
    matchBlocks."*" = {};
  };
}
