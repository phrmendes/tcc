{
  description = "Thesis environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    self,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
        fhs = pkgs.buildFHSUserEnv {
          name = "thesis";

          profile = with pkgs; ''
            export LD_LIBRARY_PATH=${cudaPackages.cudatoolkit.lib}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${cudaPackages.cudatoolkit}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${cudaPackages.cudnn}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${zlib}/lib:$LD_LIBRARY_PATH
          '';

          runScript = ''poetry shell'';

          targetPkgs = pkgs: (with pkgs; [
            duckdb
            poetry
            python312
            quarto
            ruff
            ruff-lsp
            tectonic
          ]);
        };
      in {
        devShell = fhs.env;
      }
    );
}
