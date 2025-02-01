{osConfig}: {
  inherit (osConfig.mods.desktop) enable;
  profiles.eelco = {
    id = 0;
    isDefault = true;
  };
}
