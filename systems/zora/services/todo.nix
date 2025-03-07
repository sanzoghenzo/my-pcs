{config, ...}: let
  cfg = config.webInfra;
  svcName = "todo";
in {
  services.vikunja = {
    enable = true;
    frontendHostname = "${svcName}.${cfg.domain}";
    frontendScheme = "https";
    settings = {
      service.timezone = "Europe/Rome";
      # TODO: setup rauthy!!!
      # service.enableregistration = false;
      # auth.local.enabled = false;
      # auth.openid = {
      #   enabled = true;
      #   providers = [{
      #     name = "rauthy";
      #     authurl = "https://auth.${domain}/...";  # issuer
      #     logouturl = "";
      #     clientid = "";
      #     clientsecret = "";
      #   }];
      # };
      # metrics.enabled = true;  # https://vikunja.io/docs/metrics-setup/
    };
    # environmentFiles = [];
  };

  proxiedServices."${svcName}" = {
    port = config.services.vikunja.port;
  };
  # TODO: files/attchments? config.services.vikunja.settings.files.basepath
  dailyBackup.paths = [config.services.vikunja.database.path];
}
