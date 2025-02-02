{pkgs}: {
  enableRedistributableFirmware = true;
  bluetooth.enable = true;
  graphics.extraPackages = [
    # pkgs.rocm-opencl-runtime
    ];
}
