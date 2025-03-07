_: {
  virtualisation.oci-containers.containers = {
    acestream-engine = {
      image = "vstavrinov/acestream-engine";
      autoStart = true;
      ports = ["6878:6878"];
    };
  };
}
