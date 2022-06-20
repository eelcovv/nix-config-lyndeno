{config, lib, pkgs, inputs, ...}:

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

    home-manager.users.lsanche = let
      homeCfg = config.home-manager.users.lsanche;
      commands = {
        lock = "${pkgs.swaylock-effects}/bin/swaylock";
      };
    in {
      services.avizo.enable = true;
      services.avizo.systemd.enable = true;
      xdg.configFile."avizo/config.ini".text = ''
        [default]
        block-count = 50
        background = rgba(75,75,75,1)
        bar-fg-color = rgba(200,200,200,1)
      '';
      gtk = {
          enable = true;
          theme.name = "Adwaita-dark";
          theme.package = pkgs.gnome.gnome-themes-extra;
          iconTheme.name = "Papirus-Dark";
          iconTheme.package = pkgs.papirus-icon-theme;
      };

      xdg.configFile."swaylock/config".source = ./swaylock.conf;

      services.gammastep = {
          enable = true;
          latitude = 53.6;
          longitude = -113.3;
          tray = true;
      };

      programs.waybar = let
        cssScheme = builtins.readFile (config.scheme inputs.base16-waybar); 
      in {
          enable = true;
          systemd = {
          enable = true;
          # TODO: Will be in the next release of home-manager
          #target = "sway-session.target";
          };
          # in next release will allow specifying the path to a css file
          style = cssScheme + (lib.readFile ./style.css);
          settings = [{
          position = "bottom";
          height = 10;
          modules-left = ["sway/workspaces" "sway/window"];
          modules-right = ["disk#root" "cpu" "memory" "network" "battery" "backlight" "clock" "pulseaudio" "idle_inhibitor" "tray" ];
          gtk-layer-shell = true;
          modules = {
              "disk#root" = {
              interval = 30;
              format = " {percentage_free}%";
              path = "/";
              states = {
                  "warning" = 80;
                  "high" =  90;
                  "critical" = 95;
              };
              };

              "battery" = {
              interval = 5;
              states = {
                  "warning" = 30;
                  "critical" = 15;
              };
              format-discharging = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-full = " Full";
              format-icons = ["" "" "" "" "" "" "" "" "" ""];
              };

              "clock" = {
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format = "{:%-I:%M %p}";
              format-alt = "{:%Y-%m-%d}";
              };

              "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                  "activated" = "";
                  "deactivated" = "";
              };
              };

              "tray" = {
              icon-size = 12;
              spacing = 3;
              };

              "cpu" = {
              format = " {usage}%";
              tooltip = true;
              interval = 3;
              };

              "memory" = {
              format = " {used:0.1f}G ({percentage}%)";
              interval = 3;
              };

              "backlight" = {
              device = "intel_backlight";
              format = "{icon} {percent}%";
              format-icons = [ "" "" "" "" "" "" ];
              };

              "network" = {
              format-wifi = "";
              format-ethernet = "  {bandwidthDownBits}";
              format-linked = " {ifname} (No IP)";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname} = {ipaddr}/{cidr}   {bandwidthDownBits}  {bandwidthUpBits}";
              tooltip-format-wifi = "SSID = {essid}\nAddress = {ipaddr}\nBand {frequency} MHz\nUp = {bandwidthUpBits}\nDown = {bandwidthDownBits}\nStrength = {signalStrength}%";
              interval = 2;
              };

              "pulseaudio" = {
              # "scroll-step": 1, // %, can be a float
              format = "{icon} {volume}%";
              format-bluetooth = "{icon} {volume}% {format_source} ";
              format-bluetooth-muted = "婢 {icon} {format_source}";
              format-muted = "婢";
              format-source = " {volume}%";
              format-source-muted = "";
              format-icons = {
                  "headphone" = "";
                  "hands-free" = "";
                  "headset" = "";
                  "phone" = "";
                  "portable" = "";
                  "car" = "";
                  "default" = ["奄" "奔" "墳"];
              };
              on-click = "pavucontrol";
              };
          };
          }];
      };
      wayland.windowManager.sway = let
        swayCfg = homeCfg.wayland.windowManager.sway.config;
      in {
          enable = true;
          wrapperFeatures.gtk = true;
          package = null;
          config = {
          startup = [
              { command = "dbus-update-activation-environment WAYLAND_DISPLAY"; }
              { command = "${pkgs.discord}/bin/discord --start-minimized"; }
              { command = "${pkgs.avizo}/bin/avizo-service"; }
              { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
          ];
          output."*" = { bg = "${inputs.wallpapers}/lake_louise.jpg fill"; };
          keybindings = let
              modifier = swayCfg.modifier;
              menu = swayCfg.menu;
              setVolume = "${pkgs.avizo}/bin/volumectl -u";
          in lib.mkOptionDefault {
              "${modifier}+l" = "exec ${commands.lock}";
              "${modifier}+grave" = "exec ${menu}";

              #TODO: Implement --locked
              "XF86AudioRaiseVolume" = "exec ${setVolume} up 2";
              "XF86AudioLowerVolume" = "exec ${setVolume} down 2";
              "XF86AudioMute" = "exec ${setVolume} toggle-mute";

              "print" = "exec --no-startup-id ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy && ${pkgs.wl-clipboard}/bin/wl-paste > ~/Pictures/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')";

              "${modifier}+equal" = "gaps inner all plus 10";
              "${modifier}+minus" = "gaps inner all minus 10";
              "${modifier}+Shift+minus" = "gaps inner all set ${toString swayCfg.gaps.inner}";
              "${modifier}+z" = "exec ${homeCfg.programs.alacritty.package}/bin/alacritty -e ${homeCfg.programs.nnn.package}/bin/nnn";
          };
          menu = "${pkgs.bemenu}/bin/bemenu-run";
          window.titlebar = false;
          window.commands = [
              {
              criteria = {
                  title = "^Picture-in-Picture$";
                  app_id = "firefox";
              };
              command = "floating enable, move position 877 450, sticky enable";
              }
              {
              criteria = {
                  title = "Firefox — Sharing Indicator";
                  app_id = "firefox";
              };
              command = "floating enable, move position 877 450";
              }
          ];
          window.border = 3;
          terminal = "alacritty";
          modifier = "Mod4";
          input = {
              "type:touchpad" = {
              tap = "enabled";
              natural_scroll = "enabled";
              scroll_factor = "0.2";
              };
          };
          gaps = {
              inner = 20;
              smartGaps = true;
              smartBorders = "on";
          };
          workspaceAutoBackAndForth = true;
          bars = [];
          };
      };

      services.swayidle = {
        enable = true;
        events = [
          { event = "before-sleep"; command = "${commands.lock}"; }
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
