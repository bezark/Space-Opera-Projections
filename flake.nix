{
  description = "Projection-only NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      # This is the only place we call nixosSystem,
      # directly off the flake input’s lib:
      nixosConfigurations.projectionSystem =
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            # your real, existing config:
            ./configuration.nix

            # your RTSP→v4l2loopback bits:
            ./projection-system.nix
          ];
        };
    };
}

