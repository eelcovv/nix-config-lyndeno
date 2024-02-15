{
  pkgs,
  inputs,
}:
with pkgs;
  [
    wally-cli # for moonlander
    brightnessctl # for brightness control
    gnome.gnome-tweaks
    inputs.bbase.packages.${system}.default
    gnome-firmware
    mission-center

    ettercap
    ethtool
    bettercap

    kdiskmark
  ]
  ++ (with gnomeExtensions; [
    appindicator
    #dash-to-panel
    dash-to-dock
    #tailscale-status
    tailscale-qs
    caffeine
    dash-to-panel
    just-perfection
    blur-my-shell
    media-controls
    vitals
    battery-health-charging
  ])
