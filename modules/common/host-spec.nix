# Specifications For Differentiating Hosts
{
  config,
  lib,
  ...
}:
{
  options.hostSpec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    email = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "The email of the user";
    };
    networking = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "An attribute set of networking information";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain of the host";
    };
    userFullName = lib.mkOption {
      type = lib.types.str;
      description = "The full name of the user";
    };
    handle = lib.mkOption {
      type = lib.types.str;
      description = "The handle of the user (eg: github user)";
    };
    home = lib.mkOption {
      type = lib.types.str;
      description = "The home directory of the user";
      default = "/home/${config.hostSpec.username}";
    };
    secureBoot = lib.mkOption {
      type = lib.types.bool;
      description = "Whether or not secure boot has been enabled";
      default = false;
    };
    bootHistoryLimit = lib.mkOption {
      type = lib.types.int;
      description = "How many generations to keep bootable in history";
      default = 3;
    };
    impermanance = lib.mkOption {
      type = lib.types.bool;
      description = "Whether or not to enable impermenance";
      default = false;
    };
    persist = lib.mkOption {
      type = lib.types.str;
      description = "The folder to persist data if impermenance is enabled";
      default = "/persist";
    };
    useYubikey = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate if the host uses a yubikey";
    };
    hdr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host that uses HDR";
    };
    scaling = lib.mkOption {
      type = lib.types.str;
      default = "1";
      description = "Used to indicate what scaling to use. Floating point number";
    };
    font = lib.mkOption {
      type = lib.types.str;
      default = "ComicCodeLigatures";
      description = "Used to specify the system font";
    };
  };
}
