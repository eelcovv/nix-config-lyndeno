{
  lib,
  pkgs,
}: {
  swraid.enable = false;
  loader = {
    systemd-boot.enable = lib.mkForce false;
    grub.enable = lib.mkForce false;
    timeout = 0;
    efi.canTouchEfiVariables = true;
  };
  lanzaboote = {
    enable = false;
    pkiBundle = "/etc/secureboot";
  };
  initrd = {
    systemd = {
      enable = true;
    };
    availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelModules = [
      "kvm-amd"
      "tpm_tis"
    ];
  };
  kernelParams = [
    # "acpi_rev_override=1" # nvidia card crashes things without this
    "amd_iommu=on"
  ];
  kernelPackages = pkgs.linuxPackages_latest;
  kernelModules = [
    "coretemp" # sensors-detect for Intel temperature
  ];
  binfmt.emulatedSystems = ["aarch64-linux"];
}
