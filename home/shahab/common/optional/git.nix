{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = config.hostSpec.userFullName;
        email = config.hostSpec.email.user;
      };
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      commit = {
        gpgsign = true;
      };
      user = {
        signingKey = "~/.ssh/id_rihla.pub";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      lfs = {
        locksverify = true;
      };
    };
  };
}
