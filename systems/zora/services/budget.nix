{config, ...}: {
  age.secrets.actual-oidc-config.file = ../../../secrets/actual-oidc-config.age;

  services.actual = {
    enable = true;
    settings = {
      port = 5555; # like $$$$
      loginMethod = "openid";
      openid = {
        issuer = "https://auth.sanzoghenzo.com";
        server_hostname = "https://budget.sanzoghenzo.com";
        authMethod = "oauth2";
      };
    };
  };
  systemd.services.actual.serviceConfig.environmentFile = config.age.secrets.actual-oidc-config.path;

  proxiedServices.budget.port = config.services.actual.settings.port;

  dailyBackup.paths = ["/var/lib/actual"];
}
