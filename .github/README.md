My nixos config

To install for the first time, run:

```bash
# nixos-rebuild switch --flake github:eelcovv/nix-config-lyndero#HOST 
```

This is a flake and thus requires the flake related experimental features to be enabled.

If you don't have flake installed you can either add this to your /etc/nixos/configuration, or run the command above like

```bash
# nixos-rebuild switch --extra-experimental-features "nix-command flakes"  --flake github:eelcovv/nix-config-lyndero#HOST 
```

Finally, if you have already installed your os and want to update with the new version of this repository, run

```bash
# nixos-rebuild switch --flake github:eelcovv/nix-config-lyndero#HOST  --refresh
```