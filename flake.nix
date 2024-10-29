{
  description = "Thesis environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    utils,
    nixpkgs,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
      in {
        devShells.default = with pkgs;
          mkShell {
            packages = [
              python312
              quarto
              tectonic
              uv
            ];

            shellHook = ''
              VENV="./.venv/bin/activate"

              if [[ ! -f $VENV ]]; then
                ${pkgs.uv}/bin/uv venv
              fi

              source "$VENV"
            '';

            LD_LIBRARY_PATH = lib.makeLibraryPath [
              stdenv.cc.cc
              zlib
              cudaPackages.cudatoolkit
              cudaPackages.cudnn
              cudaPackages.tensorrt
            ];
          };
      }
    );
}
