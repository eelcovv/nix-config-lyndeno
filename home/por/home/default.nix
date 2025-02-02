{
  pkgs,
  osConfig,
}: {
  username = "por";
  homeDirectory = "/home/por";
  enableNixpkgsReleaseCheck = true;
  shellAliases = {
    cat = "${pkgs.bat}/bin/bat";
  };
  inherit (osConfig.system) stateVersion;
}
