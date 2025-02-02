{
  lib,
  pkgs,
}: {
  swraid.enable = false;
  loader = {
    systemd-boot.enable = lib.mkForce true;
    grub.enable = lib.mkForce false;
    timeout = 0;
    efi.canTouchEfiVariables = true;
  };

  # lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };
  initrd = {
    systemd = {
      enable = true;
    };
    availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelModules = [
      "kvm-amd"
    ];
    luks.devices."luks-b3f33672-edb8-4154-96c1-d1344ab0e130".device = "/dev/disk/by-uuid/b3f33672-edb8-4154-96c1-d1344ab0e130";
  };
  kernelParams = [
    "acpi_rev_override=1" # nvidia card crashes things without this
  ];
  kernelPackages = pkgs.linuxPackages_latest;
  kernelModules = [
    "coretemp" # 
  ];
  binfmt.emulatedSystems = ["aarch64-linux"];
}
