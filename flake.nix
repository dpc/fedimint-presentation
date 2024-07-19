{
  description = "Rust + htmx + tailwind + nix + redb metric tracking service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        presentation = pkgs.runCommandLocal "make-presentation-out" { } /* sh */ ''
          set -euo pipefail

          cp -a ${./.}/* ./

          export PATH="${pkgs.just}/bin/:${pkgs.mermaid-cli}/bin/:$PATH"
            
          just mermaid-render-all

          mkdir -p "$out/share/doc"
          cp *.md "$out/share/doc/"
          cp *.png "$out/share/doc/"
        '';

        present = pkgs.writeShellScriptBin "present.sh" ''
          ${pkgs.presenterm}/bin/presenterm ${presentation}/share/doc/presentation.md
        '';
      in
      {
        packages = {
          inherit presentation present;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.presenterm
            pkgs.mermaid-cli
          ];
        };
      }
    );
}
