{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.prowlarr.enable = cfg.enable;
    services.prowlarr.openFirewall = cfg.openPorts;
  };
}
