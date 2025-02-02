  {
    isNormalUser = true;
    description = "Eelco van Vliet";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };