{
  pkgs,
  inputs,
  osConfig,
}: {
  inherit (osConfig.mods.desktop) enable;
  package = pkgs.jetbrains.pycharm-community-bin;
}
