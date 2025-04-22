{config, ...}: let
  cfg = config.webInfra;
  hubPort = 8083;
  dataDir = "/data/store";
  svcName = "files";
  fqdn = "https://${svcName}.${cfg.domain}";
  baseAuthUrl = "https://auth.${cfg.domain}";
  serverPrefix = "/seafhttp";
  seafileCfg = config.services.seafile;
in {
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0770 - ${seafileCfg.group} - -"
  ];

  services.seafile = {
    enable = true;
    dataDir = dataDir;
    seahubAddress = "127.0.0.1:${toString hubPort}";
    ccnetSettings.General.SERVICE_URL = fqdn;
    adminEmail = "andrea.ghensi@gmail.com";
    initialAdminPassword = "chang3m3!";
    # TODO: add gc?
  };

  proxiedServices.files.port = hubPort;
  services.traefik.dynamicConfigOptions.http = {
    routers.seafile-server = {
      service = "seafile-server";
      rule = "Host(`${svcName}.${cfg.domain}`) && PathPrefix (`${serverPrefix}`)";
      tls.certResolver = "production";
      middlewares = ["seafhttp-strip"];
    };
    services.seafile-server.loadBalancer.servers = [
      {url = "http://localhost:${toString seafileCfg.seafileSettings.fileserver.port}";}
    ];
    middlewares.seafhttp-strip.stripPrefix.prefixes = [serverPrefix];
  };
}
