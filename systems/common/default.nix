{ inputs, lib, config, pkgs, ...}:
{
  imports = [ 
    ./boot.nix
    ./cleanup.nix
  ];
  config ={
    nix.settings.experimental-features = "nix-command flakes";
    console.keyMap = "uk";
    time.timeZone = "Europe/Rome";
    i18n.defaultLocale = "it_IT.UTF-8";
  };
}
