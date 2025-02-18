# My nixos

# 🚀 Installing NixOS from a Live ISO Using Flakes

This guide explains how to install NixOS from a **Live ISO** using a **GitHub-hosted flake configuration**, even if you have multiple host-specific configurations.

---

## **1️⃣ Boot into the NixOS Live ISO**
- Download and boot from the [NixOS installation ISO](https://nixos.org/download.html).
- Open a terminal.

---

## **2️⃣ Connect to the Internet**
If using **Wi-Fi**, run:  
```sh
nmtui
```
- Select **Activate a Connection** and connect to your network.

To verify connectivity:  
```sh
ping -c 3 nixos.org
```

---

## **3️⃣ Set Up Your Disks**
If your disk isn’t partitioned, format it:
```sh
sudo fdisk /dev/sdX  # Replace "sdX" with your actual disk (e.g., /dev/nvme0n1)
```
Then create partitions, for example:
```sh
mkfs.ext4 /dev/sdX1  # Format root partition
mkswap /dev/sdX2     # Format swap
swapon /dev/sdX2     # Enable swap
```
Mount the root partition:
```sh
mount /dev/sdX1 /mnt
```

If using **LUKS encryption, ZFS, or Btrfs**, configure accordingly.

---

## **4️⃣ Clone Your NixOS Flake Configuration**
First, install `git`:
```sh
nix-env -iA nixpkgs.git
```
Then, clone your configuration repo:
```sh
git clone https://github.com/yourusername/nixos-config.git /mnt/etc/nixos
```
(*Replace `yourusername/nixos-config` with your actual repo URL.*)

---

## **5️⃣ Temporarily Set Hostname to Match Flake**
Since your flake has multiple configurations based on hostname, set a temporary hostname:
```sh
hostnamectl set-hostname my-laptop
```
(*Replace `my-laptop` with the hostname matching your flake!*)

Verify the hostname:
```sh
hostnamectl
```

---

## **6️⃣ Enable Flakes in the Live Session**
Flakes aren’t enabled by default, so install and enable them:
```sh
nix-env -iA nixpkgs.nixFlakes
```

---

## **7️⃣ Install NixOS Using Your Flake**
Now, install your system using your flake configuration:
```sh
sudo nixos-install --flake /mnt/etc/nixos#my-laptop
```
(*Replace `my-laptop` with the hostname matching your flake!*)  

⚡ **This will install NixOS using your GitHub flake configuration!**

---

## **8️⃣ Reboot into Your New System**
Once the installation is complete, unmount and reboot:
```sh
umount -R /mnt
reboot
```
Now, you should boot into your fully configured NixOS system! 🚀

---

## **💡 Bonus: Automate Host Detection in Your Flake**
If you want **automatic hostname detection**, modify `flake.nix` like this:
```nix
let
  hostname = builtins.readFile "/etc/hostname";
in
nixosConfigurations.${hostname}
```
Then you can install without manually setting the hostname:
```sh
sudo nixos-install --flake /mnt/etc/nixos
```

---

## **✅ Summary**
| Step  | Action  |
|-------|---------|
| 1️⃣   | Boot into Live ISO |
| 2️⃣   | Connect to the internet |
| 3️⃣   | Set up disk partitions and mount `/mnt` |
| 4️⃣   | Clone flake repository to `/mnt/etc/nixos` |
| 5️⃣   | Set a temporary hostname to match flake config |
| 6️⃣   | Enable Nix flakes in the live environment |
| 7️⃣   | Install NixOS using `nixos-install --flake` |
| 8️⃣   | Unmount and reboot |

Now you have a **fully automated NixOS installation with flakes**! 🎉
