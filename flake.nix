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

      in
      {
        packages = { };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.presenterm
            pkgs.mermaid-cli
          ];
        };
      }
    );
}
