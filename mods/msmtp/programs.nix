{
  pkgs,
  config,
}: {
  msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "off";
    };
    accounts = {
      default = {
        host = "smtp.gmail.com";
        passwordeval = "${pkgs.busybox}/bin/cat ${config.age.secrets.fastmail_pass.path}";
        user = "eelcovv@gmail.com.com";
        # must be adjuste for eelco
        from = "${config.networking.hostName}@system.lyndeno.ca";
      };
    };
  };
}
