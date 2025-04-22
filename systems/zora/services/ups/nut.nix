{config, ...}: {
  age.secrets.nut-password.file = ../../../../secrets/nut-password.age;

  power.ups = {
    enable = true;
    # TODO: use "netserver" on zora and "netclient" on holodeck
    mode = "standalone";
    ups.tecnoware = {
      description = "Tecnoware Era Plus 1100";
      driver = "blazer_usb";
      port = "auto";
      directives = [
        "langid_fix = 0x409"
        # "vendorid = 0665"
        # "productid = 5161"
      ];
    };
    # if config.power.ups.mode == "netserver" then "primary-client" else "secondary-client";
    upsmon.monitor.tecnoware.user = "primary-client";
    users = {
      primary-client = {
        # UPS connected to this machine, shut it down last
        passwordFile = config.age.secrets.nut-password.path;
        upsmon = "primary";
      };
      secondary-client = {
        # UPS connected to another machine, shutdown this one first
        passwordFile = config.age.secrets.nut-password.path;
        upsmon = "secondary";
      };
    };
  };
}
