{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.calibre-web = {
      enable = cfg.enable;
      group = cfg.group;
      options = {
        calibreLibrary = cfg.booksDir;
        enableBookUploading = true;
      };
      listen.ip = "0.0.0.0";
      openFirewall = cfg.openPorts;
    };

    # services.calibre-web.dataDir can be without the leading /var/lib,
    # using hardcoded path for now
    dailyBackup.paths = ["/var/lib/calibre-web"];
  };
}
