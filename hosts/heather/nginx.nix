{ ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.users.nginx.extraGroups = [ "acme" ];

  security.acme = {
    acceptTerms = true;
    certs = {
      "cowe.dev".email = "scott.t.cowe@gmail.com";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "cowe.dev" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          return = "200 \"Hello from mywebsite!\"";
        };
      };
    };
  };
}
