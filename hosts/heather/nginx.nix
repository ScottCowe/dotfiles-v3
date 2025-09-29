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
        # locations."/frontend-6484481303f37e26_bg.wasm" = {
        #   proxyPass = "http://127.0.0.1:8080";
        # };
        # locations."/frontend-6484481303f37e26.js" = {
        #   proxyPass = "http://127.0.0.1:8080";
        # };
        # locations."/" = {
        #   proxyPass = "http://127.0.0.1:8080";
        #   tryFiles = "$uri $uri/ /index.html";
        # };
        locations."/api" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };
}
