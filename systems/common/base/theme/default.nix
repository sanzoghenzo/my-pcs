{pkgs, ...}: let
  inherit ((import ./colours.nix)) colours;
  libx = import ./lib.nix {inherit (pkgs) lib;};
in rec {
  inherit (libx) hexToRgb;
  inherit colours;

  catppuccin = {
    flavor = "macchiato";
    accent = "blue";
    size = "standard";
  };

  wallpaper = ./wallpapers/wallpaper.png;

  gtkTheme = {
    name = "catppuccin-${catppuccin.flavor}-${catppuccin.accent}-${catppuccin.size}+normal";
  };

  qtTheme = {
    name = "Catppuccin-Macchiato-Blue";
    package = pkgs.catppuccin-kvantum.override {
      variant = "Macchiato";
      accent = "Blue";
    };
  };

  iconTheme = rec {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
    iconPath = "${package}/share/icons/${name}";
  };

  cursorTheme = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
  };

  fonts = {
    default = {
      name = "Inter";
      package = pkgs.inter;
      size = "11";
    };
    iconFont = {
      name = "Inter";
      package = pkgs.inter;
    };
    monospace = {
      name = "MesloLGSDZ Nerd Font Mono";
      package = pkgs.nerd-fonts.meslo-lg;
    };
    emoji = {
      name = "OpenMoji Color";
      package = pkgs.openmoji-color;
    };
  };
}
