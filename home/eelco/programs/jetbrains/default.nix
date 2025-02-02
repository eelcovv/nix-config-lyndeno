{
  pkgs,
  inputs,
  osConfig,
}: {
  inherit (osConfig.mods.desktop) enable;
  package = pkgs.jetrains-pycharm-comunity-bin;
}
