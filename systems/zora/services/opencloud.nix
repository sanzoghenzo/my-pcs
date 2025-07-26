{config, ...}: let
  dataDir = "/data/opencloud";
  svcName = "files";
  domain = "sanzoghenzo.com";
  openCloudCfg = config.services.opencloud;
in {
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0777 ${openCloudCfg.user} ${openCloudCfg.group} - -"
  ];

  services.opencloud = {
    enable = true;
    url = "https://${svcName}.${domain}";
    # settings = { };
    environment = {
      OC_INSECURE = "true";
      PROXY_TLS = "false";
      PROXY_HTTP_ADDR = "127.0.0.1:${toString openCloudCfg.port}";
      STORAGE_USERS_POSIX_ROOT = dataDir;
      # OC_OIDC_ISSUER = "https://auth.${domain}";
      # PROXY_OIDC_REWRITE_WELLKNOWN = "true";
      # PROXY_AUTOPROVISION_ACCOUNTS = "true";
    };
    # environmentFile con secrets
  };

  systemd.services.opencloud.serviceConfig.ReadWritePaths = [dataDir];

  proxiedServices."${svcName}".port = openCloudCfg.port;
  # quando smetto di fare il taccagno, aggiungo dataDir,
  # oppure uso direttamente backend s3
  dailyBackup.paths = [openCloudCfg.stateDir];
}
