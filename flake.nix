{
  description = "RTSP to Virtual Webcam Service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or stable if you prefer
  };

  outputs = { self, nixpkgs, ... }: {
    nixosModules.virtualCam = { config, lib, pkgs, ... }: {
      options.virtualCam = {
        enable = lib.mkEnableOption "Enable virtual webcam RTSP service";
        rtspUrl = lib.mkOption {
          type = lib.types.str;
          default = "rtsp://your-default-stream.example.com";
          description = "RTSP URL to stream into the virtual webcam";
        };
      };

      config = lib.mkIf config.virtualCam.enable {
        environment.systemPackages = [
          pkgs.ffmpeg
          pkgs.v4l2loopback
        ];

        boot.kernelModules = [
          "v4l2loopback"
        ];

        systemd.services.virtualCam = {
          description = "Virtual Webcam from RTSP Stream";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = ''
              ${pkgs.ffmpeg}/bin/ffmpeg \
                -rtsp_transport tcp \
                -i ${config.virtualCam.rtspUrl} \
                -f v4l2 \
                -codec:v rawvideo \
                -pix_fmt yuv420p \
                /dev/video0
            '';
            Restart = "always";
            RestartSec = "5s";
          };
        };
      };
    };
  };
}
