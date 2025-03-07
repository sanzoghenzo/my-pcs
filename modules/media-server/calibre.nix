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
  };
}
