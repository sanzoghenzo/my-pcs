{config, ...}: let
  dataDir = "/data/media/photo";
  cfg = config.services.immich;
  svcName = "photo";
  domain = config.webInfra.domain;
in {
  services.immich = {
    enable = true;
    mediaLocation = dataDir;
    settings.server.externalDomain = "https://${svcName}.${domain}";
    group = "multimedia";
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0770 ${cfg.user} multimedia - -"
  ];

  proxiedServices."${svcName}".port = cfg.port;
}
