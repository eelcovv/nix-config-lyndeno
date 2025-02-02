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


Preparation

1. Install nixos first from the installation disk. 
    -  Choose xfce, as it is lightweight and small. non desktop is possible, but you need to find out how to connect to wifi from the command terminal
    - Set hardrive encription on
2. Login to the freshly installed system and copy */etc/nixos/configuration.nix* and */etc/nixos/hardware-configuration.nix* to you working system where you can include
   the fileSystem
   - Copy the   fileSystem information from the hardware-configuration.nix to your information in the file fileSystem.nix. This is importan to couple your encrypted hardrives and swapspace



