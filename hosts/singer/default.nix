{
  lib,
  pkgs,
  ...
}: 
{

  programs.dconf.enable = true;
  programs.niri.enable = true;

  security.tpm2.enable = true;

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';

    # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };


  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking = {
    networkmanager = {
      enable = true;
      settings.connectivity = {
        uri = "http://google.com/generate_204";
        response = "";
      };
    };
    useDHCP = lib.mkDefault true;
  };


  environment.systemPackages = with pkgs; [
    libsmbios # For fan control
    sbctl
    gnome-network-displays
    fuzzel
  ];
}
