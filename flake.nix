{
  description = "Dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        fhs = pkgs.buildFHSUserEnv {
          name = "pixi";

          targetPkgs = pkgs: (with pkgs; [
            pixi
          ]);
        };
      in {
        devShell = fhs.env;
      }
    );
}
