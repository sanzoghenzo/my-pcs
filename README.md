# my PCs configurations

An attempt to use the NixOS ecosystem to deploy and provision my home machines.

## usage

Activate the nix development environment with

```shell
nix develop --impure
```

Deploy to the machines using task

```shell
task viewscreen
```

the task is a simple wrapper to

```shell
deploy .#viewscreen
```

The target node (viewscreen in this case) should already have NixOS installed.

## VM testing

to run a vm, use:

```shell
task viewscreen-vm
```

At the first launch, login eith the user root and password "test", then run `reboot`.
This will load the kodi user services and boot kodi at start.

## New system

- Install NixOS
- Edit /etc/nixos/configuration.nix to add:

  ```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [ git ];
  ```

- `sudo nixos-rebuild switch`

Then you can clone the repo and enter the dev environment with `nix develop`.

When you're ready, apply the configuration with

```shell
sudo nixos-rebuild --flake .#configName switch
```

where configName is the `nixosConfiguration` that you want to use on the system.
