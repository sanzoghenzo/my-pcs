{ config, lib, ... }:
let
  cfg = config.baseServer;
in
{
  options.baseServer = {
    enable = lib.mkEnableOption "baseServer";
    # wol = lib.mkOption 
  };

  config = lib.mkIf cfg.enable {
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0F+u3b7vu0bxtVSbRHDsIjAa1UjgDTCe/9tIN5uGXhouZMqL+nuMWptEdcygev6fXAupXDntUypZ21vUBVmVcUsxv/Vwpf7gjyTUmlSAaLPPq0R0TPzgL7HEEKsiXVOAKbuHoZlXvjGjupASlnNE3shw7GO/Wb80jjXP+PgoqvpqPud1bl2kGadD6VrgUneplx480ibMLG6CGIw30aEXisbq2N5HbkWYIzpSU8ZqJPCWMnMQ5dvPj9RYtbGh0irlOUcUtEyDcLXZ3kbbNb5pZY2FqUqay9nf5f2K2r66eRXQEHi3JNbg5lanJkvvfriACNtYM9dtRVsfyIuOSETP"
    ];
    services.openssh.enable = true;

    networking = {
      usePredictableInterfaceNames = false;
      interfaces.eth0.wakeOnLan.enable = true;
      nat = {
        enable = true;
        externalInterface = "eth0";
      };
      iproute2.enable = true;
    };

    # region VM config for tests
    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 4;
        graphics = lib.mkDefault false;
        forwardPorts = [
          {
            from = "host";
            host.port = 2222;
            guest.port = 22;
          }
        ];
      };
      users.users.root.password = "test";
      services.resolved.extraConfig = lib.mkForce "";
      networking.wg-quick.interfaces = lib.mkForce { };
    };
    # endregion
  };
}
