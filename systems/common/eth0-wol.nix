{ ... }:
{
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      wakeOnLan.enable = true;
    };
    nat = {
      enable = true;
      externalInterface = "eth0";
    };
    iproute2.enable = true;
  };
}
