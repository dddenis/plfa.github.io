{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = _: prev: { };

        pkgs = import nixpkgs {
          inherit system;

          overlays = [
            inputs.devshell.overlays.default
            overlay
          ];
        };

      in
      {
        devShell = pkgs.devshell.mkShell {
          motd = "";
          packages = with pkgs; [
            emacs
            (agda.withPackages (p: [ p.standard-library ]))
          ];
        };
      }
    );
}
