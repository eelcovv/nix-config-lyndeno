{
  pkgs,
  inputs,
  osConfig,
}: {
  inherit (osConfig.mods.desktop) enable;
  package = pkgs.vscode;
  enableExtensionUpdateCheck = true;
  enableUpdateCheck = false;
}