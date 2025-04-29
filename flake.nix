{
  description = "Multi-config NixOS flake: workstation + projection-system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs   = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {
        # 1) Your regular machine
        workstation = pkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };

        # 2) The projection system with virtual webcam
        projectionSystem = pkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # ./configuration.nix
            ./projection-system.nix
          ];
        };
      };
    };
}
