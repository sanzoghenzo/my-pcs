# Enable home row mode on the laptop keyboard
{
  config,
  lib,
  ...
}: let
  cfg = config.homeRowMod;
in {
  options.homeRowMod = {
    enable = lib.mkEnableOption "homeRodMod";
    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "list of keyboard devices to apply the home row mod to";
    };
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards.homeRowMod = {
        devices = cfg.devices;
        extraDefCfg = "process-unmapped-keys yes";
        # TODO: evaluate https://github.com/jtroo/kanata/blob/main/cfg_samples/home-row-mod-advanced.kbd
        config = ''
          (defsrc
            a   s   d   f   j   k   l   ;
          )
          (defvar
            tap-time 200
            hold-time 300
          )
          (defalias
            a (tap-hold $tap-time $hold-time a lmet)
            s (tap-hold $tap-time $hold-time s lalt)
            d (tap-hold $tap-time $hold-time d lctl)
            f (tap-hold $tap-time $hold-time f lsft)
            j (tap-hold $tap-time $hold-time j rsft)
            k (tap-hold $tap-time $hold-time k rctl)
            l (tap-hold $tap-time $hold-time l ralt)
            ; (tap-hold $tap-time $hold-time ; rmet)
          )
          (deflayer base
            @a  @s  @d  @f  @j  @k  @l  @;
          )
        '';
      };
    };
  };
}
