{
  pkgs,
  osConfig,
}: {
  username = "eelco";
  homeDirectory = "/home/eelco";
  enableNixpkgsReleaseCheck = true;
  shellAliases = {
    cat = "${pkgs.bat}/bin/bat";
  };
  inherit (osConfig.system) stateVersion;
}
