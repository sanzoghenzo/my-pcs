{ config, ... }:
let
  # TODO: make this a parameter
  mediaDir = "/data/media";
  booksDir = "${mediaDir}/books";
in
{
  services.calibre-web = {
    enable = true;
    group = group;
    options = {
      calibreLibrary = booksDir;
      enableBookUploading = true;
    };
    listen.ip = "0.0.0.0";
  };

  imports = [
    (import ../expose-service.nix {
      name = "books";
      port = config.services.calibre-web.listen.port;
      cert = "staging";
    })
  ];
}
