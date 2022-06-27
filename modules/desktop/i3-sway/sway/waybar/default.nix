{lib, cssScheme}:
{
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
}