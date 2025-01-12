{ lib, ... }:
{
  imports = [
    ./traefik.nix
    ./cloudflare.nix
    ./adguard.nix
    ./auth.nix
    ./expose-service.nix
  ];

  options.webInfra = {
    enable = lib.mkEnableOption "base web infrastructure";
    domain = lib.mkOption {
      type = lib.types.str;
      description = ''
        Domain to expose the services to (without the subdomain).
      '';
      default = "sanzoghenzo.com";
    };
  };
}
