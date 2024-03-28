{
  description = "Thesis environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    utils,
    nixpkgs,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        fhs = pkgs.buildFHSUserEnv {
          name = "thesis";
          targetPkgs = pkgs: (with pkgs; [micromamba]);
          profile = ''
            export MAMBA_ROOT_PREFIX="./.mamba"
            export DEPENDENCIES

            eval "$(micromamba shell hook --shell=posix)"

            if [[ -f "./env.yml" ]]; then
              DEPENDENCIES="-f env.yml"
            fi

            if [[ -f "./conda-lock.yml" ]]; then
              DEPENDENCIES+=" -f conda-lock.yml"
            fi

            if [[ -d "./.mamba" ]]; then
              micromamba update $DEPENDENCIES --yes
            else
              micromamba create $DEPENDENCIES --yes
            fi

            micromamba activate thesis
          '';
        };
      in {
        devShell = fhs.env;
      }
    );
}
