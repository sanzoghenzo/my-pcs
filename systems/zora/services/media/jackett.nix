{ ... }:
{
  # TODO: replace with prowlarr?
  services.jackett = {
    enable = true;
    group = "multimedia";
  };

  imports = [
    (import ../expose-service.nix {
      name = "jackett";
      port = 9117;
      cert = "staging";
    })
  ];
  # TODO: dns
}
