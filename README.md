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
