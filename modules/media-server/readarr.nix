{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.readarr = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    dailyBackup.paths = [config.services.readarr.dataDir];
  };
  # services.readarr.dataDir + config.xml
}
