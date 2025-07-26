{config, ...}: {
  services.openthread-border-router = {
    enable = true;
    logLevel = "debug";
    radio = {
      device = "/dev/serial/by-id/usb-1a86_USB_Single_Serial_579B024480-if00";
      baudRate = 460800;
    };
    web = {
      enable = true;
      listenAddress = "0.0.0.0";
    };
  };

  networking.firewall.allowedTCPPorts = [config.services.openthread-border-router.web.listenPort];

  services.matter-server.enable = true;
}
