# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      <impermanence/nixos.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "i915.enable_fbc=1"
    "i915.enable_psr=2"
    "acpi_rev_override=1"
  ];
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.luks.devices = {
    "nixcrypt" = {
      preLVM = true;
      device = "/dev/disk/by-label/nixcrypt";
    };
  };

  # Graphics
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.useGlamor = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
  hardware.opengl.driSupport = true;

  fileSystems = {
	  "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "noatime" "mode=755" ];
	  };

    "/nix" = {
      device = "/dev/nixpool/nixpersist";
      fsType = "ext4";
      neededForBoot = true;
    };

	  "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };
  environment.persistence."/nix/persist" = {
		directories = [
			"/etc/NetworkManager/system-connections"
      "/root"
      "/etc/nixos"
      "/var/log"
		];
		files = [
			"/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
		];
	};

  swapDevices =
    [ { device = "/dev/nixpool/nixswap"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
