{
  config,
  pkgs,
  lib,
  ...
}: let
  # nodeRedPackages = [
  #   "@flowfuse/node-red-dashboard"
  #   "@node-red-contrib-themes/theme-collection"
  #   "node-red-contrib-arp"
  #   "node-red-contrib-bigtimer"
  #   "node-red-contrib-chronos"
  #   "node-red-contrib-comfort"
  #   "node-red-contrib-node-homie-red"
  #   "node-red-contrib-oauth2" # buggy netatmo
  #   "node-red-contrib-spline-curve"
  #   "node-red-contrib-sun-position"
  #   "node-red-contrib-zigbee2mqtt"
  #   "node-red-node-openweathermap"
  #   "node-red-contrib-telegrambot"
  # ];
  # https://discourse.nixos.org/t/how-to-make-additional-package-available-to-the-service/17007/5
  myNodeRed =
    pkgs.runCommand "node-red"
    {
      nativeBuildInputs = [pkgs.makeWrapper];
    }
    ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.nodePackages.node-red}/bin/node-red $out/bin/node-red \
        --set PATH '${
        lib.makeBinPath [
          pkgs.git
          pkgs.openssh
          pkgs.nodePackages.npm
          pkgs.gcc
          pkgs.unixtools.arp
        ]
      }:$PATH' \
    '';
in {
  services.node-red = {
    enable = true;
    package = myNodeRed;
    configFile = ./settings.js;
  };
  # https://github.com/node-red/node-red/issues/2420
  programs.ssh.knownHosts."github.com".publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";

  proxiedServices.iot = {
    port = config.services.node-red.port;
  };
}
