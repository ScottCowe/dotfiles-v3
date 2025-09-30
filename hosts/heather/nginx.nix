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
        locations."~ \.(html|js|wasm)$" = {
          proxyPass = "http://127.0.0.1:8080";
        };
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          extraConfig = ''
            rewrite .* /index.html break;
          '';
        };
        locations."/api" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };
}
