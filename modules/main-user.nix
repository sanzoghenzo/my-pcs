{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.user;
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "sanzo";
      description = "User login name.";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Andrea Ghensi";
      description = "Full name of the user.";
    };
    publicKey = lib.mkOption {
      type = lib.types.str;
      default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0F+u3b7vu0bxtVSbRHDsIjAa1UjgDTCe/9tIN5uGXhouZMqL+nuMWptEdcygev6fXAupXDntUypZ21vUBVmVcUsxv/Vwpf7gjyTUmlSAaLPPq0R0TPzgL7HEEKsiXVOAKbuHoZlXvjGjupASlnNE3shw7GO/Wb80jjXP+PgoqvpqPud1bl2kGadD6VrgUneplx480ibMLG6CGIw30aEXisbq2N5HbkWYIzpSU8ZqJPCWMnMQ5dvPj9RYtbGh0irlOUcUtEyDcLXZ3kbbNb5pZY2FqUqay9nf5f2K2r66eRXQEHi3JNbg5lanJkvvfriACNtYM9dtRVsfyIuOSETP";
      description = "public SSH key";
    };
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      description = cfg.fullName;
      extraGroups =
        [
          "audio"
          "networkmanager"
          "users"
          "video"
          "wheel"
          "dialout"
        ]
        ++ ifExists [
          "docker"
          "plugdev"
          "render"
          "libvirtd"
        ];
      openssh.authorizedKeys.keys = [ cfg.publicKey ];
      shell = pkgs.nushell;
    };
    nix.settings.trusted-users = [ cfg.name ];

    # Create dirs for home-manager
    systemd.tmpfiles.rules = lib.mkIf (cfg.name != null) [
      "d /nix/var/nix/profiles/per-user/${cfg.name} 0755 ${cfg.name} root"
    ];
  };
}
