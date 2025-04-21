_: {
  virtualisation.oci-containers.containers = {
    acestream-engine = {
      image = "vstavrinov/acestream-engine";
      autoStart = true;
      ports = ["6878:6878" "8621:8621" "8621:8621/udp"];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [8621];
    allowedUDPPorts = [8621];
  };
}
