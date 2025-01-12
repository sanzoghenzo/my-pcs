{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mediaServer;
in
{
  config = {
    services.silverbullet = {
      enable = true;
      listenAddress = if cfg.openPorts then "0.0.0.0" else "127.0.0.1";
      openFirewall = cfg.openPorts;
      listenPort = 3002;
      extraArgs = [ "--user sanzo:#d5l5&VgHdmL3D55" ];
    };

    systemd.services.silverbullet = {
      path = with pkgs; [
        git
        openssh
        bash
      ];
      serviceConfig = {
        Environment = [
          "DENO_DIR=/var/cache/silverbullet/deno"
          "SB_KV_DB=/var/lib/silverbullet/silverbullet.db"
        ];
        CacheDirectory = "silverbullet";
      };
    };

    proxiedServices.notes = {
      port = config.services.silverbullet.listenPort;
    };
  };
}
