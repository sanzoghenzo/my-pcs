{ config, ... }:
let
  # TODO: use argument
  mediaDir = "/data/media";
  downloadsDir = "${mediaDir}/downloads";
in
{
  services.deluge = {
    enable = true;
    group = "multimedia";
    web.enable = true;
    declarative = true;
    config = {
      enabled_plugins = [ "Label" ];
      download_location = downloadsDir;
    };
    authFile = config.age.secrets.deluge-auth.path;
  };

  age.secrets.deluge-auth = {
    file = ../../../../secrets/deluge-auth.age;
    owner = "deluge";
    group = "multimedia";
    mode = "440";
  };

  imports = [
    (import ../expose-service.nix {
      name = "torrent";
      port = config.services.deluge.web.port;
      cert = "staging";
    })
  ];
}
