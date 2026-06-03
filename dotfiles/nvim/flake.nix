{
  description = "Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fenixLib = fenix.packages.${system};
        rustToolchain = fenixLib.stable.toolchain;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            lua-language-server
            stylua
            ripgrep
            fd
            nil

            nodejs_24
            python313
            rustToolchain
          ];

          shellHook = ''
            echo "Neovim development environment"
            echo "nvim is configured with your local config"
          '';
        };
      }
    );
}
