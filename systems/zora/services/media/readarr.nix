{ config, lib, ... }:
let
  cfg = config.mediaServer;
in
{
  config = lib.mkIf cfg.enable {
    services.readarr = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    proxiedServices.readarr = {
      port = 8787;
      cert = "staging";
    };
  };
  # services.readarr.dataDir + config.xml
}
