{ config, ... }:
{
  services.bazarr = {
    enable = true;
    group = "multimedia";
  };

  imports = [
    (import ../expose-service.nix {
      name = "bazarr";
      port = config.services.bazarr.listenPort;
      cert = "staging";
    })
  ];
  # TODO: dns

  # /var/lib/${config.systemd.services.bazarr.serviceConfig.StateDirectory} + config.ini
  # config.ini
}
