{config, lib, pkgs, inputs, ...}:

with lib;

let
  cfg = config.modules.desktop;
in
{
  config = mkIf ((cfg.environment == "sway") && cfg.enable) {
    programs.gnupg.agent.pinentryFlavor = "gnome3";

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway --config /etc/greetd/sway-config";
          user = "greeter";
        };
      };
    };

    environment.etc = {
      "greetd/sway-config".text = ''
        exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s ${pkgs.gnome-themes-extra}/share/themes/Adwaita-dark/gtk-3.0/gtk.css ; swaymsg exit"
        bindsym Mod4+shift+e exec swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot' \
        -b 'Suspend' 'systemctl suspend-then-hibernate' \
        -b 'Hibernate' 'systemctl hibernate'
        input "type:touchpad" {
          tap enabled
        }
        include /etc/sway/config.d/*
      '';
      "greetd/environments".text = ''
        sway
        zsh
        bash
      '';
    };
    
    security = {
      pam.services = {
        login.u2fAuth = false;
        greetd.u2fAuth = false;
        greetd.enableGnomeKeyring = true;
      };
      polkit.enable = true;
    };
    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      wlr.enable = true;
      gtkUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
          bemenu
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

    home-manager.users.lsanche = let
      swaylock-config = pkgs.callPackage ./swaylock.nix { thm = config.scheme; };
      commands = {
        lock = "${pkgs.swaylock}/bin/swaylock -C ${swaylock-config}";
      };
    in {

      services.gammastep = {
          enable = true;
          latitude = 53.6;
          longitude = -113.3;
          tray = true;
      };

      programs.waybar = { enable = true; } // import ./sway/waybar { inherit lib; cssScheme = builtins.readFile (config.scheme inputs.base16-waybar);};
      wayland.windowManager.sway = with config.scheme.withHashtag; {
          enable = true;
          wrapperFeatures.gtk = true;
          package = null;
          config = import ./common.nix {
            inherit commands pkgs lib;
            wallpaper = "${import ./wallpaper.nix { inherit config pkgs; } { height = 1080; width = 1920; }}";
            thm = config.scheme;
            # TODO: We use this to access our set terminal packages. Pass through that instead
            homeCfg = config.home-manager.users.lsanche;
          };
      };

      services.swayidle = {
        enable = true;
        events = [
          { event = "before-sleep"; command = "if ! pgrep swaylock; then ${commands.lock}; fi"; }
        ];
        timeouts = let
          runInShell = name: cmd: "${pkgs.writeShellScript "${name}" ''${cmd}''}";
          screenOn = runInShell "swayidle-screen-on" ''
            swaymsg "output * dpms on"
          '';
        in
          [
          {
            timeout = 30;
            command = runInShell "swayidle-lockscreen-timeout" ''
              if pgrep swaylock
              then
                swaymsg "output * dpms off"
              fi
            '';
            resumeCommand = screenOn;
          }
          {
            timeout = 300;
            command = "${commands.lock}";
          }
          {
            timeout = 310;
            command = runInShell "swayidle-screen-off" ''
              swaymsg "output * dpms off"
            '';
            #resumeCommand = runInShell "swayidle-screen-on" ''
            #  swaymsg "output * dpms on"
            #'';
            resumeCommand = screenOn;
          }
          {
            timeout = 900;
            command = "${pkgs.writeShellScript "swayidle-sleep-when-idle" ''
              if [ $(${pkgs.acpi}/bin/acpi -a | cut -d" " -f3 | cut -d- -f1) = "off" ]
              then
                systemctl suspend-then-hibernate
              fi
            ''}";
          }
        ];
      };

      # Referenced https://github.com/stacyharper/base16-mako/blob/master/templates/default.mustache
      programs.mako = with config.scheme.withHashtag; {
          enable = true;
          anchor = "bottom-right";
          backgroundColor = base00;
          borderColor = base0D;
          textColor = base05;
          borderRadius = 5;
          borderSize = 2;
          defaultTimeout = 10000;
          font = "CaskcaydiaCove Nerd Font 12";
          groupBy = "summary";
          layer = "overlay";
      };
    };
  };
}
