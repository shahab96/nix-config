{
  description = "My NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland cachix flake
    hyprland.url = "github:hyprwm/Hyprland";

    # NixOS community managed hardware specific features/fixes
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets
    nix-secrets = {
      url = "git+ssh://git@git.dogar.dev/shahab/nix-secrets?shallow=1&ref=main";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    mkHost = host: {
      ${host} = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;

          # Extend lib with lib.custom
          lib = nixpkgs.lib.extend (self: super: {
            custom = import ./lib {inherit (nixpkgs) lib;};
          });
        };

        modules = [./hosts/nixos/${host}];
      };
    };
    mkHostConfigs = hosts:
      lib.foldl (acc: set: acc // set) {}
      (lib.map (host: mkHost host) hosts);
    readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
  in {
    nixosConfigurations = mkHostConfigs (readHosts "nixos");

    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [nil lua-language-server kubernetes-helm kubectl];
      };
  };
}
