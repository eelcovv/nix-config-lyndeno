{
  devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "229.17G";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  preLVM = true;
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "nixpool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      nixpool = {
        type = "lvm_vg";
        lvs = {
          nixswap = {
            size = "8.8";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          nixroot = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
