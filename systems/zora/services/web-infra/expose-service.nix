{
  config,
  lib,
  ...
}: let
  serviceType = lib.types.submodule {
    options = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = ''
          Domain to expose the service to (without the subdomain).
        '';
        default = config.webInfra.domain;
      };
      targetHost = lib.mkOption {
        type = lib.types.str;
        description = ''
          Name or IP of the host to forward the traffic to.
        '';
        default = "localhost";
      };
      port = lib.mkOption {
        type = lib.types.int;
        description = ''
          HTTP port at which the service listens to.
          Traefik will terminate TLS and forward traffic to this port.
        '';
      };
      cert = lib.mkOption {
        type = lib.types.str;
        description = ''
          Certificate resolver to use.
          Can be "staging" or "production".
          Set it to staging during the initial tests.
        '';
        default = "production";
      };
      targetIp = lib.mkOption {
        type = lib.types.str;
        description = ''
          Name of the host running the service.
          It will be used by the internal DNS to do masquerading.
        '';
        default = config.hostInventory.zora.ipAddress;
      };
      secure = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to use https between traefik and the service.
        '';
        default = false;
      };
      # TODO: forward auth
    };
  };
  cfg = config.proxiedServices;
in {
  options.proxiedServices = lib.mkOption {
    type = lib.types.attrsOf serviceType;
    description = ''
      The names of the attribute set will be used as subdomains.
    '';
  };

  config = {
    services.traefik.dynamicConfigOptions.http = {
      routers =
        lib.mapAttrs
        (name: svc: {
          rule = "Host(`${name}.${svc.domain}`)";
          tls.certResolver = svc.cert;
          service = name;
        })
        cfg;
      services =
        lib.mapAttrs
        (name: svc: let
          scheme = "http${
            if svc.secure
            then "s"
            else ""
          }";
        in {
          loadBalancer.servers = [
            {
              url = "${scheme}://${svc.targetHost}:${builtins.toString svc.port}";
            }
          ];
        })
        cfg;
    };
    services.adguardhome.settings.filtering.rewrites = lib.attrValues (
      lib.mapAttrs
      (name: svc: {
        domain = "${name}.${svc.domain}";
        answer = svc.targetIp;
        # answer = "${svc.lanHostname}.lan";
      })
      cfg
    );
  };
}
