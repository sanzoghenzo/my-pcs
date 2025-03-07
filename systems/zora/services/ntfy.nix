{
  config,
  pkgs,
  ...
}: let
  cfg = config.webInfra;
  svcName = "ntfy";
  fqdname = "${svcName}.${cfg.domain}";
  url = "https://${fqdname}";
  port = 2586;
in {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = url;
      behind-proxy = true;
      auth-default-access = "read-only";
    };
  };
  # TODO: user creation is only available via commands

  proxiedServices."${svcName}" = {
    port = port;
  };

  age.secrets.ntfy-token.file = ../../../secrets/ntfy-token.age;

  systemd.services."notify-failure@" = {
    enable = true;
    description = "Failure notification for %i";
    scriptArgs = "%i"; # Content after '@' will be sent as '$1' in the below script
    script = ''
      ${pkgs.curl}/bin/curl \
      --fail --show-error --silent --max-time 10 --retry 3 \
      -H "Authorization: Bearer $(cat ${config.age.secrets.ntfy-token.path})" \
      --data "$1 exited with errors" ${url}/failures
    '';
  };

  # use this to enable notification on failing services - make it a function!
  # systemd.services."${name}".unitConfig.OnFailure = [
  #   "notify-failure@${name}.service"
  # ];
}
