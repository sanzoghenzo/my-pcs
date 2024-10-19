{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/disable-idle-timeout.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              { node.name = "~alsa_input.*" }
              { node.name = "~alsa_output.*" }
            ]
            actions = {
              update-props = {
                session.suspend-timeout-seconds = 0
              }
            }
          }
        ]
      '')
    ];
  };

  environment.systemPackages = [ pkgs.ncpamixer ];
}
