{
  description = "Python and R environments for running student scripts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [ "dyalog" ];
      };
      python = pkgs.python3.withPackages (ps: with ps; [
        numpy matplotlib tkinter jupyter ipykernel scipy
      ]);

      histData_1_1 = pkgs.rPackages.HistData.overrideAttrs (oldAttrs: rec {
        version = "1.1-0";
        src = pkgs.fetchFromGitHub {
          owner = "friendly";
          repo = "HistData";
          rev = "master";
          hash = "sha256-zzrzREWCO/Ci1N2dq79FrZcyEU3FYPRkp6SUxEvZy6M=";
        };
      });
      hasseDiagram = pkgs.rPackages.buildRPackage {
        name = "hasseDiagram";
        version = "0.2.0";
        src = pkgs.fetchurl {
          url = "https://cran.r-project.org/src/contrib/Archive/hasseDiagram/hasseDiagram_0.2.0.tar.gz";
          hash = "sha256-8BTrklzfFki76iFjLEmWo142udrCyB7+uxWbh+TnJNo=";
        };
        propagatedBuildInputs = with pkgs.rPackages; [ Rgraphviz graph ];
      };
      renv = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          ggplot2
          knitr
          hasseDiagram
          rmarkdown
          fcaR
          ggraph
          histData_1_1
          shiny
          pracma
        ];
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          (pkgs.haskellPackages.ghcWithPackages (hp: [ hp.gnuplot hp.JuicyPixels]))
          pkgs.gnuplot
          python
          renv
          pkgs.tk
          pkgs.quarto
          pkgs.pandoc
          pkgs.go
          pkgs.racket
          pkgs.ruby
          pkgs.ocaml
          pkgs.swi-prolog
          pkgs.nodejs_22
          pkgs.typescript
          pkgs.tsx
          pkgs.pnpm
          pkgs.pkg-config
          pkgs.rustc
          pkgs.cargo
          (pkgs.dyalog.override { acceptLicense = true; })
        ];

        nativeBuildInputs = [
          pkgs.pkg-config
        ];

        buildInputs = [
          pkgs.fontconfig
          pkgs.freetype
        ];
        
        shellHook = ''
            export QUARTO_R=${renv}/bin/R
            export QUARTO_PYTHON=${python}/bin/python
              '';       
      };
    };
}
