{ ... }:
{
  services.prowlarr.enable = true;

  imports = [
    (import ../expose-service.nix {
      name = "prowlarr";
      port = 9696;
      cert = "staging";
    })
  ];
  # TODO: dns
}
