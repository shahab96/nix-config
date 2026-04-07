{
  pkgs,
  config,
  lib,
  ...
}:
let
  hostSpec = config.hostSpec;
in
{
  specialisation.gaming.configuration = {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };

      # to run steam games in game mode, add the following to the game's properties from within steam
      # gamemoderun %command%
      gamemode.enable = true;
    };

    home-manager.users."${hostSpec.username}".imports = lib.flatten [
      (
        { config, ... }:
        import (lib.custom.relativeToRoot "home/${hostSpec.username}/specialisations/gaming.nix") {
          inherit pkgs;
        }
      )
    ];

    powerManagement.cpuFreqGovernor = "performance";

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-qt
    ];
  };
}
