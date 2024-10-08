{
  description = "Flake for Dooit Bar Utils";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }
  :
    flake-utils.lib.eachDefaultSystem (
      system: let
        name = "dooit-bar-utils";
        version = "0.1.0";

        pkgs = import nixpkgs {inherit system;};
        python3 = pkgs.python312Packages;

        mainPkgs = with python3; [
          textual
        ];
      in {
        packages.default = python3.buildPythonPackage {
          pname = name;
          version = version;
          src = ./.;
          format = "pyproject";

          # nativeBuildInputs = with pkgs; [
          # ];

          pythonRelaxDeps = [
            "textual"
          ];

          buildInputs = mainPkgs;

          doCheck = false; # no tests
        };

        # Deps: Devshell
        devShell = pkgs.mkShell {
          name = "dooit-bar-utils";
          buildInputs =
            mainPkgs
            ++ (with pkgs; [
              bun
            ]);
        };
      }
    );
}
