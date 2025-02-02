{
  "/" = { 
    device = "/dev/disk/by-uuid/f4ed3ac4-bc11-4746-b188-a27e30f4950d";
    fsType = "ext4";
  };

 "/boot" =
    { device = "/dev/disk/by-uuid/F4BD-6F94";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
}
