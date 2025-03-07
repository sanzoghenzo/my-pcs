{config, ...}: {
  dailyBackup = {
    enable = true;
    paths = [
      "/var/lib/containers/storage/volumes"
      "/var/lib/silverbullet"
      "/var/lib/node-red/"
    ];
    exclude = [
      "/var/lib/silverbullet/silverbullet.db*"
      "/var/lib/silverbullet/_plug"
    ];
  };
}
