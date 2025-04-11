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

## Secrets management

I'm using [agenix](https://github.com/ryantm/agenix) to store the secrets in a secure way.

To add a new one:

- add an entry to the `secrets/secrets.nix` with the file name and the users/groups that can read it
- cd to the `secrets` folder and run `agenix -e <file name>` (the one specified the step above)
- type in and save the secret. It will be encoded, and can be safely added to git.

## New system

- Install NixOS (TODO: investigate nixos-anywhere)
- `curl -O https://github.com/sanzoghenzo.keys`
- Edit /etc/nixos/configuration.nix to add:

  ```nix
  users.users.sanzo.openssh.authorizedKeys.keys = [
    "<alt+ins to add the key from the previously downloaded files>"
  ];
  services.openssh.enable = true;
  ```

- `sudo nixos-rebuild switch`

- On your main computer, add the host to the `program.ssh.matchBlocks` option in `home/default.nix` and rebuild the config (since my main pc is discovery, a `task discovery` will work fine)
- create a new folder for the new system in the `systems` folder: `mkdir -p systems/<newname>`
- copy over the `hardware-configuration.nix` file: `scp <newname>:/etc/hardware-configuration.nix systems/newname/`
- create the `systems/<newname>/default.nix` file by taking inspiration from other existing systems
- add a `<newname>` item in `nixosConfigurations` and one in `deploy.nodes` in the `flake.nix` file, following the existing ones.
- once you have finished configuring, use `deploy <newname>` to build and deploy it to the system.
- you can also add the task in the `Taskfile`

### access secrets

- Copy the content of the `/etc/ssh/ssh_host_ed25519_key.pub` file
- Open the `secrets\secrets.nix`
- add a new variable with the new system name and the key (like the others)
- add this variable to the pertaining groups and/or directly to the secrets `publikKeys`

Finally run `agenix --rekey`

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
