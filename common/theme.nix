{pkgs, lib, inputs, ...}:
let
  base16Scheme = "${inputs.base16-schemes}/gruvbox-dark-hard.yaml";
in {
    stylix = {
      image = "${inputs.wallpapers}/starry.jpg";
      base16Scheme = base16Scheme;
      targets.swaylock.useImage = false;
      fonts = let
        cascadia = (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; });
      in {
        serif = {
          package = cascadia;
          name = "CaskaydiaCove Nerd Font";
        };
        sansSerif = {
          package = cascadia;
          name = "CaskaydiaCove Nerd Font";
        };
        monospace = {
          package = cascadia;
          name = "CaskaydiaCove Nerd Font Mono";
        };
      };
  };
}