{ config, ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscale-key.path;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  age.secrets.tailscale-key.file = ../../../secrets/tailscale.age;
}
