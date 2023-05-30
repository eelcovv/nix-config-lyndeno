_: {
  stylix.targets = {
    gnome.enable = false;
    gtk.enable = false;
  };

  services.borgbackup.repos = {
    neo = {
      path = "/data/borg/neo";
      authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/jyR1sMTHU3LoSweCtlAQwtaeUJGw/2LmOAKDuEXE3"];
    };
    morpheus = {
      path = "/data/borg/morpheus";
      authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6nNQlJ+zzi+fmwDnXJ4eZXbp2JrS3fe2m04DlvstkO"];
    };
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:Lyndeno/nix-config/master";
    allowReboot = true;
    dates = "Mon, 03:30";
  };

  services.openssh = {
    enable = true;
  };

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?
}
