{
  desktop,
  pkgs,
  self,
  ...
}:
let
  theme = import ../base/theme { inherit pkgs; };
in
{
  imports = [ ../services/pipewire.nix ];

  # Enable Plymouth and surpress some logs by default.
  boot.plymouth.enable = true;
  boot.kernelParams = [
    # The 'splash' arg is included by the plymouth option
    "quiet"
    "loglevel=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  hardware.graphics.enable = true;

  fonts = {
    packages = with pkgs; [
      liberation_ttf
      ubuntu_font_family

      theme.fonts.default.package
      theme.fonts.emoji.package
      theme.fonts.iconFont.package
      theme.fonts.monospace.package
    ];

    # Use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "${theme.fonts.default.name}"
          "${theme.fonts.emoji.name}"
        ];
        sansSerif = [
          "${theme.fonts.default.name}"
          "${theme.fonts.emoji.name}"
        ];
        monospace = [ "${theme.fonts.monospace.name}" ];
        emoji = [ "${theme.fonts.emoji.name}" ];
      };
    };
  };
}
