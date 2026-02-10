{ inputs, ... }:

{
  flake.nixosModules.cowedev =
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

      containers.cowedev = {
        autoStart = true;

        bindMounts = {
          "/var/www" = {
            hostPath = "/mnt/cowedev-data";
            isReadOnly = false;
          };
        };

        config =
          { config, pkgs, ... }:
          {
            networking.firewall.allowedTCPPorts = [
              8080
              3000
            ];

            services.postgresql = {
              enable = true;
              ensureDatabases = [ "cowedev" ];
              authentication = pkgs.lib.mkOverride 10 ''
                #type database  DBuser  auth-method
                local all       all     trust
              '';
            };

            environment.systemPackages = [
              inputs.cowedev.packages.${pkgs.system}.frontend
              inputs.cowedev.packages.${pkgs.system}.backend
              pkgs.static-web-server
            ];

            services.static-web-server = {
              enable = true;
              listen = "127.0.0.1:8080";
              root = "${inputs.cowedev.packages.${pkgs.system}.frontend}";
              configuration.general = {
                index-files = "";
              };
            };

            systemd.services.cowedev = {
              description = "cowe.dev website";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              requires = [ "postgresql.service" ];
              serviceConfig = {
                Environment = "SOCKET_PATH=/var/run/postgresql/ DATA_DIR=/var/www DB_NAME=cowedev DB_USER=postgres";
                ExecStart = "${inputs.cowedev.packages.${pkgs.system}.backend}/bin/backend";
                Restart = "always";
                StandardOutput = "journal";
                StandardError = "journal";
              };
            };

            system.stateVersion = "25.05";
          };
      };
    };
}
