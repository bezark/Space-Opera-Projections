# flake.nix
{
  description = "Godot with correct libstdc++";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.godot_4
          pkgs.gcc14.lib
        ];

        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.gcc14.lib}/lib:$LD_LIBRARY_PATH
          echo "LD_LIBRARY_PATH set for Godot. Run 'godot' or './Godot_binary'."
        '';
      };
    };
}
