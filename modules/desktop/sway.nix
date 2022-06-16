{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.modules.desktop;
in
{
  config = mkIf ((cfg.environment == "sway") && cfg.enable) {
    programs.gnupg.agent.pinentryFlavor = "gnome3";
    services.xserver = {
      displayManager.gdm.enable = true;
    };
    security.pam.services.login.u2fAuth = false;
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      wlr.enable = true;
      gtkUsePortal = true;
    };

    programs = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
          swaylock
          swayidle
          wl-clipboard
          mako
          alacritty
          wofi
          waybar
          gammastep
          playerctl
          slurp
          grim
          acpi
        ];
      };
      seahorse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome.nautilus
    ];
  };
}
