{config, ...}: let
  cfg = config.webInfra;
  svcName = "todo";
  frontendHostname = "${svcName}.${cfg.domain}";
  frontendScheme = "https";
in {
  age.secrets.vikunja-envvars.file = ../../../secrets/vikunja-envvars.age;

  services.vikunja = {
    enable = true;
    frontendHostname = frontendHostname;
    frontendScheme = frontendScheme;
    settings = {
      service.timezone = "Europe/Rome";
      service.enableregistration = false;
      auth.local.enabled = false;
      auth.openid = {
        enabled = true;
        redirecturl = "${frontendScheme}://${frontendHostname}/auth/openid/pocketid";
        providers.pocketid = {
          name = "Pocket-Id";
          authurl = "https://auth.${cfg.domain}";
        };
      };
      # metrics.enabled = true;  # https://vikunja.io/docs/metrics-setup/
    };
    environmentFiles = [config.age.secrets.vikunja-envvars.path];
  };

  proxiedServices."${svcName}" = {
    port = config.services.vikunja.port;
  };
  # TODO: files/attchments? config.services.vikunja.settings.files.basepath
  dailyBackup.paths = [config.services.vikunja.database.path];
}
