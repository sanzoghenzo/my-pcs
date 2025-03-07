{...}: let
  dataDir = "/var/lib/psa-car-controller";
in {
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0770 - root - -"
  ];

  virtualisation.oci-containers.containers.psa-car-controller = {
    image = "flobz/psa_car_controller:v3.5.3";
    autoStart = true;
    ports = ["5000:5000"];
    volumes = ["${dataDir}:/config"];
  };
}
