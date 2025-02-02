{
  pkgs,
  lib,
  config,
  pubKeys,
}: let
  keys = pubKeys.por;
in {
  isNormalUser = true;
  description = "Karnrawee Mangkang";
  uid = 1001;
  initialPassword = "test";
  extraGroups = [
    "wheel"
    "media"
    (lib.mkIf config.networking.networkmanager.enable "networkmanager") # Do not add this group if networkmanager is not enabled
    (lib.mkIf config.programs.adb.enable "adbusers")
    (lib.mkIf config.programs.wireshark.enable "wireshark")
    "libvirtd"
    "dialout"
    "plugdev"
    "uaccess"
  ];
  shell = pkgs.fish;
  openssh.authorizedKeys.keys = [
    (lib.mkIf (keys ? ${config.networking.hostName}) keys.${config.networking.hostName})
  ];
}
