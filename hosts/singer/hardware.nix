{pkgs}: {
  enableRedistributableFirmware = true;
  bluetooth.enable = true;
  graphics.extraPackages = [
    (pkgs.callPackage <nixpkgs/pkgs/development/compilers/rocm/opencl-runtime> {})
    ];
}
