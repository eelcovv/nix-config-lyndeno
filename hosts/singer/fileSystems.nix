{
  "/" = { 
    device = "/dev/disk/by-uuid/461e766c-3384-45c7-856e-3987d725d35d";
    fsType = "ext4";
  };

 "/boot" =
    { device = "/dev/disk/by-uuid/C234-C9D1";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
}
