{ ... }:
{
  services.readarr = {
    enable = true;
    group = "multimedia";
  };

  imports = [
    (import ../expose-service.nix {
      name = "readarr";
      port = 8787;
      cert = "staging";
    })
  ];
  # TODO: dns
  # services.readarr.dataDir + config.xml
}
