My nixos config

To install for the first time, run:

```bash
nixos-rebuild switch --flake github:eelcovv/nix-config-lyndeno#HOST 
```

This is a flake and thus requires the flake related experimental features to be enabled.

If you don't have flake installed you can either add this to your /etc/nixos/configuration, or run the command above like

```bash
nixos-rebuild switch --extra-experimental-features "nix-command flakes"  --flake github:eelcovv/nix-config-lyndeno#HOST 
```

You can also add the lines:

```sh
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

to your */etc/nixos/configuration.nix* file



Finally, if you have already installed your os and want to update with the new version of this repository, run

```bash
nixos-rebuild switch --flake github:eelcovv/nix-config-lyndeno#HOST  --refresh
```


Preparation

1. Install nixos first from the installation disk.

    - Choose xfce, as it is lightweight and small. No desktop is possible, but you need to find out how to connect to wifi from the command terminal
    - In case you choose the terminal installation, you can switch on wifi in the */etc/nixos/configuration.nix* (*wireless.enable*). But apparently, this does work.
    - Set hardrive encription on
    - Choose a swap partition

2. After instalation: 
    - login to your new system.
    - copy the */etc/nixos/configuration.nix* and  */etc/nixos/hardware-configuration.nix* to a usb drive and insert in your other machine where this repo is locatie. 
    - Copy the fileSystem information from the hardware-configuration.nix to your information in the file fileSystem.nix. This is importan to couple your encrypted hardrives and swapspace
    - Modify the */etc/nixos/configution.nix" to switch the hostname to your desired hostname, enable ssh, and add the flakes line above to the configuration. 

Run:

```bash
sudo nixos-rebuild switch 
```

This will change your hostname, so that you can install the hostname from the github
