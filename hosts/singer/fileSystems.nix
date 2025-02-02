{
  "/" = { 
    device = "/dev/disk/by-uuid/1a077db1-9c94-43cf-b532-b6565dd1d119";
    fsType = "ext4";
  };

 "/boot" =
    { device = "/dev/disk/by-uuid/C234-C9D1";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
}
