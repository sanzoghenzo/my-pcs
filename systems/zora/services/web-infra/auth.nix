{config, ...}: let
  cfg = config.webInfra;
  svcName = "auth";
  fqdname = "${svcName}.${cfg.domain}";
  frontendPort = 4074; # "auth" in leet (more or less)
  backendPort = 9455; # "pass" in leet
  backendUrl = "http://localhost:${toString backendPort}";
in {
  services.pocket-id = {
    enable = true;
    # environmentFile = "path...";
    settings = {
      PUBLIC_APP_URL = "https://${fqdname}";
      INTERNAL_BACKEND_URL = backendUrl;
      TRUST_PROXY = true;
      PORT = frontendPort;
      BACKEND_PORT = backendPort;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers = {
      auth = {
        service = "auth";
        rule = "Host(`${fqdname}`)";
        tls.certResolver = "production";
      };
      auth-backend = {
        service = "auth-backend";
        rule = "Host(`${fqdname}`) && PathRegexp(`^/(api|\.well-known)/`)";
        tls.certResolver = "production";
      };
    };
    services = {
      auth.loadBalancer.servers = [
        {url = "http://localhost:${toString frontendPort}";}
      ];
      auth-backend.loadBalancer.servers = [
        {url = backendUrl;}
      ];
    };
    middlewares = {
      auth-headers.headers = {
        sslRedirect = true;
        stsSeconds = 315360000;
        browserXssFilter = true;
        contentTypeNosniff = true;
        forceSTSHeader = true;
        sslHost = cfg.domain;
        stsIncludeSubdomains = true;
        stsPreload = true;
        frameDeny = true;
      };
    };
  };

  services.adguardhome.settings.filtering.rewrites = [
    {
      domain = fqdname;
      answer = config.hostInventory.zora.ipAddress;
    }
  ];

  dailyBackup.paths = [
    config.services.pocket-id.dataDir
  ];
}
