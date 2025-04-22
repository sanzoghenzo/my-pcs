{lib, ...}: let
  hostInfo = lib.types.submodule {
    options = {
      description = lib.mkOption {
        type = lib.types.str;
        description = "Description of the device";
        default = "";
      };
      macAddress = lib.mkOption {
        type = lib.types.str;
        description = "MAC address of the device";
      };
      ipAddress = lib.mkOption {
        type = lib.types.str;
        description = "IP Address of the device";
      };
    };
  };
in {
  options.hostInventory = lib.mkOption {
    type = lib.types.attrsOf hostInfo;
    description = ''
      Attributes with the hostName as top-level keys
      and information to use inside the configurations as low level key-value pair
    '';
  };

  config = {
    hostInventory = {
      zora = {
        description = "Intel NUC as server";
        macAddress = "94:c6:91:ad:f5:cb";
        ipAddress = "192.168.1.225";
      };
      viewscreen = {
        description = "Asus VM65N as HTPC";
        macAddress = "78:24:af:04:37:cb";
        ipAddress = "192.168.1.224";
      };
      holodeck = {
        description = "Thinkcentre M920q as old server";
        macAddress = "f8:75:a4:b1:e6:9a";
        ipAddress = "192.168.1.220";
      };
      discovery = {
        description = "Dell XPC 15 as everyday laptop";
        macAddress = "9c:b6:d0:ee:f3:13";
        ipAddress = "192.168.1.103";
      };
      tricorder = {
        description = "Samsung Galaxy a52s as everyday smartphone";
        macAddress = "96:a6:6b:1f:86:5f";
        ipAddress = "192.168.1.2";
      };
      sveglia-comodino = {
        description = "huawei used as bedroom alarm clock";
        macAddress = "a4:93:3f:e5:70:88";
        ipAddress = "192.168.1.209";
      };
      modem = {
        description = "Sorgenia Router";
        macAddress = "";
        ipAddress = "192.168.1.1";
      };

      # IoT (Shelly)
      ## Smart switches
      luce-camera = {
        description = "Bedroom light switches";
        macAddress = "58:bf:25:d8:0e:43";
        ipAddress = "192.168.1.20";
      };
      caldaia = {
        description = "Shelly relay for heater";
        macAddress = "58:bf:25:d8:5a:b0";
        ipAddress = "192.168.1.21";
      };
      luce-salotto = {
        description = "Living room ";
        macAddress = "8c:aa:b5:5d:68:57";
        ipAddress = "192.168.1.22";
      };
      bedroom-switches = {
        macAddress = "98:cd:ac:2c:8a:62";
        ipAddress = "192.168.1.23";
      };
      lavatrice = {
        macAddress = "e8:db:84:d7:d3:72";
        ipAddress = "192.168.1.50";
      };
      entertainment-hub = {
        macAddress = "e8:db:84:d4:d1:1b";
        ipAddress = "192.168.1.51";
      };
      homelab-pm = {
        macAddress = "48:e1:e9:62:bf:49";
        ipAddress = "192.168.1.52";
      };
      ## EM
      energy-monitor = {
        macAddress = "c4:5b:be:79:51:7c";
        ipAddress = "192.168.1.5";
      };
      ## vaacum cleaner
      dot = {
        description = "Vaacuum";
        macAddress = "b0:4a:39:65:85:4a";
        ipAddress = "192.168.1.6";
      };
      ## Roller shutters
      tapparella-bagno = {
        macAddress = "c8:c9:a3:79:fa:86";
        ipAddress = "192.168.1.10";
      };
      tapparella-camera-letto = {
        macAddress = "c8:c9:a3:7a:36:6c";
        ipAddress = "192.168.1.11";
      };
      tapparella-soggiorno-est = {
        macAddress = "98:cd:ac:38:c2:69";
        ipAddress = "192.168.1.12";
      };
      tapparella-soggiorno-sud = {
        macAddress = "98:cd:ac:2c:96:aa";
        ipAddress = "192.168.1.13";
      };
      tapparella-cucina = {
        macAddress = "98:cd:ac:38:df:b8";
        ipAddress = "192.168.1.14";
      };
      ## Weather/ air quality Sensor
      # netatmo = {
      #   ipAddress = "192.168.168.89";
      #   macAddress = "70:ee:50:2c:cf:34";
      # };

      # Tests
      # ??? = {
      #   macAddress = "00:26:b0:e4:f2:ec";
      #   ipAddress = "192.168.1.180";
      # };
      # oneplus = {
      #   macAddress = "00:03:7f:c2:00:43";
      #   ipAddress = "192.168.1.232";
      # };
      # motog = {
      #   macAddress = "9e:c1:46:3d:95:c6";
      #   ipAddress = "192.168.1.231";
      # };
    };
  };
}
