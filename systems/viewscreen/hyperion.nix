{pkgs, ...}: {
  environment.systemPackages = [pkgs.hyperion-ng];
  networking.firewall = {
    allowedTCPPorts = [
      8090
      19445
    ];
  };
  systemd.services.hyperion = {
    enable = true;
    description = "Hyperion ambient light";
    unitConfig = {
      Wants = ["network-online.target"];
      After = [
        "network-online.target"
        "systemd-resolved.service"
      ];
      Requisite = ["network.target"];
    };
    serviceConfig = {
      ExecStart = "${pkgs.hyperion-ng}/bin/hyperiond";
      # WorkingDirectory=/usr/share/hyperion/bin
      # User=%i
      # TimeoutStopSec=5
      # KillMode=mixed
      # Restart=on-failure
      # RestartSec=2
    };
    wantedBy = ["multi-user.target"];
  };
}
