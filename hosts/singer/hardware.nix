{config, lib, pkgs}: {
  enableRedistributableFirmware = true;
  bluetooth.enable = true;
  graphics.extraPackages = [
    # pkgs.rocm-opencl-runtime
    ];
  cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
