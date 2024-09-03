# my PCs configurations

An attempt to use the NixOS ecosystem to deploy and provision my home machines.

## usage

Activate the nix development environment with

```shell
nix develop
```

Make the adjustments you need, then run a check without building anything

```shell
task check  # equivalent to nix "flake check --no-build"
```

Deploy to the machines using task

```shell
task viewscreen  # equivalent to "deploy .#viewscreen"
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

## upgrades

This flake uses `nixos-unstable`, because I like to live on the bleeding edge!

To properly get the updated packages, do `task update` once in a while

## nixpkgs testing notes

To test a package to be added to nixpkgs, one can use

```shell
NIX_PATH=nixpkgs=<local-path> nix-shell --pure -p package-name
```

For a kodi plugin this would be

```shell
NIX_PATH=nixpkgs=<local-path> nix-shell --pure -p "kodi-wayland.withPackages (kp: with kp; [plugin-name])"
kodi
```
