{ ... }:
{
  users.groups.sanzo = {};
  users.users.sanzo = {
    isNormalUser = true;
    description = "Andrea Ghensi";
    group = "sanzo";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
