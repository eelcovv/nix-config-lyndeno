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
    luks.devices."luks-d6560107-9567-42eb-89cf-146446f76f99".device = "/dev/disk/by-uuid/d6560107-9567-42eb-89cf-146446f76f99";
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
