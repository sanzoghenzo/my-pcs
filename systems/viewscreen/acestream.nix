{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    acestream-engine = {
      image = "vstavrinov/acestream-engine";
      autoStart = true;
      ports = [ "6878:6878" ];
    };
  };
}
