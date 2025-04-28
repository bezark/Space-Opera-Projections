{
  description = "Godot with correct libstdc++";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system;
        config = {
          allowUnfree = true;  # <-- Allow unfree packages
        };

       };

    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.godot
          pkgs.stdenv.cc.cc.lib  # <-- this will have the correct libstdc++.so.6
          pkgs.ndi
        ];

        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.ndi}/lib:$LD_LIBRARY_PATH
          echo "LD_LIBRARY_PATH set for Godot with libstdc++ and ndi."
        '';
      };
    };
}
