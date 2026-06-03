{ ... }:

{
  flake.nixosModules.not-piracy =
    let
      downloadsPath = "/mnt/media/downloads";
      moviesPath = "/mnt/media/movies";
      tvShowsPath = "/mnt/media/tv";
    in
    { pkgs, ... }:
    {
      users.groups.media = { };

      systemd.tmpfiles.rules = [
        "d ${downloadsPath} 0770 - media - -"
        "d ${moviesPath} 0770 - media - -"
        "d ${tvShowsPath} 0770 - media - -"
      ];

      networking.firewall.allowedTCPPorts = [ 8080 ];

      services.jellyfin = {
        enable = true;
        openFirewall = true;
        group = "media";
      };

      services.prowlarr = {
        enable = true;
        openFirewall = true;
        settings.server.port = 8082;
      };
      systemd.services.prowlarr.serviceConfig.NetworkNamespacePath = "/var/run/netns/mullvad";

      services.sonarr = {
        enable = true;
        openFirewall = true;
        settings.server.port = 8083;
        group = "media";
      };
      systemd.services.sonarr.serviceConfig.NetworkNamespacePath = "/var/run/netns/mullvad";

      services.radarr = {
        enable = true;
        openFirewall = true;
        settings.server.port = 8084;
        group = "media";
      };
      systemd.services.radarr.serviceConfig.NetworkNamespacePath = "/var/run/netns/mullvad";

      services.qbittorrent = {
        enable = true;
        openFirewall = true;
        group = "media";

        webuiPort = 8081;

        serverConfig = {
          LegalNotice.Accepted = true;
          Preferences = {
            WebUI = {
              Username = "admin";
              Password_PBKDF2 = "@ByteArray(j5TcOQWNPJXF9uL2rcbbiA==:v41IHOXJe1QgpDwAzf2BSMO6zy4Nk2vkB6+p5tgPHpioozw/uraIcxrXTJOz28Ovec4MuIseoFzLmvzpMFAbkQ==)";
            };
            General.Locale = "en";
          };
          BitTorrent = {
            Session = {
              DefaultSavePath = downloadsPath;
              TempPath = "${downloadsPath}/incomplete";
              AddExtensionToIncompleteFiles = true;
              TempPathEnabled = true;
              DisableAutoTMMByDefault = false;
            };
          };
        };
      };
      systemd.services.qbittorrent.serviceConfig.NetworkNamespacePath = "/var/run/netns/mullvad";

      boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
      environment.etc."netns/mullvad/resolv.conf".text = "nameserver 10.64.0.1";

      systemd.services."netns@" = {
        description = "%I network namespace";
        before = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
          ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
        };
      };

      sops.secrets."mullvad-private-key" = { };
      sops.secrets."mullvad-peer-key" = { };

      systemd.services.wg-mullvad = {
        description = "wg network interface (mullvad)";
        bindsTo = [ "netns@mullvad.service" ];
        requires = [ "network-online.target" ];
        after = [ "netns@mullvad.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart =
            with pkgs;
            writers.writeBash "wg-up" ''
              set -ex
              ${iproute2}/bin/ip link add wg0 type wireguard
              ${iproute2}/bin/ip link set wg0 netns mullvad
              ${iproute2}/bin/ip -n mullvad address add 10.65.137.90/32 dev wg0
              ${iproute2}/bin/ip -n mullvad -6 address add fc00:bbbb:bbbb:bb01::2:8959/128 dev wg0
              ${iproute2}/bin/ip netns exec mullvad \
              ${wireguard-tools}/bin/wg set wg0 listen-port 51820 private-key <(cat /run/secrets/mullvad-private-key) \
              peer $(cat /run/secrets/mullvad-peer-key) endpoint 141.98.252.130:51820 allowed-ips +0.0.0.0/0,+::0/0
              ${iproute2}/bin/ip -n mullvad link set wg0 up
              ${iproute2}/bin/ip -n mullvad -6 route add default dev wg0
              ${iproute2}/bin/ip -n mullvad route add default dev wg0 table 2468
              ${iproute2}/bin/ip -n mullvad rule add not fwmark 1 table 2468
              ${iproute2}/bin/ip link add veth0 type veth peer name veth1 netns mullvad
              ${iproute2}/bin/ip -n mullvad addr add 10.0.0.2/24 dev veth1
              ${iproute2}/bin/ip addr add 10.0.0.1/24 dev veth0
              ${iproute2}/bin/ip -n mullvad link set lo up
              ${iproute2}/bin/ip -n mullvad link set dev veth1 up
              ${iproute2}/bin/ip link set dev veth0 up
              ${iproute2}/bin/ip -n mullvad route add default via 10.0.0.1 dev veth1
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 127.0.0.1 --dport 8081 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 100.103.153.89 --dport 8081 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 127.0.0.1 --dport 8082 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 100.103.153.89 --dport 8082 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 127.0.0.1 --dport 8083 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 100.103.153.89 --dport 8083 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 127.0.0.1 --dport 8084 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -A PREROUTING -p tcp --dst 100.103.153.89 --dport 8084 -j DNAT --to 10.0.0.2
              ${iproute2}/bin/ip netns exec mullvad ${iptables}/bin/iptables -A PREROUTING -t mangle -i veth1 -p tcp -j MARK --set-mark 1
              ${iproute2}/bin/ip netns exec mullvad ${iptables}/bin/iptables -A PREROUTING -t mangle -m mark --mark 0x1 -j CONNMARK --save-mark
              ${iproute2}/bin/ip netns exec mullvad ${iptables}/bin/iptables -A OUTPUT -t mangle -j CONNMARK --restore-mark
            '';
          ExecStop =
            with pkgs;
            writers.writeBash "wg-down" ''
              set -ex
              ${iproute2}/bin/ip netns exec mullvad ${iptables}/bin/iptables -D PREROUTING -t mangle -i veth1 -p tcp -j MARK --set-mark 1
              ${iproute2}/bin/ip netns exec mullvad ${iptables}/bin/iptables -D PREROUTING -t mangle -m mark --mark 0x1 -j CONNMARK --save-mark
              ${iproute2}/bin/ip netns exec mullvad ${iptables}/bin/iptables -D OUTPUT -t mangle -j CONNMARK --restore-mark
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 127.0.0.1 --dport 8081 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 100.114.224.96 --dport 8081 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 127.0.0.1 --dport 8082 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 100.114.224.96 --dport 8082 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 127.0.0.1 --dport 8083 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 100.114.224.96 --dport 8083 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 127.0.0.1 --dport 8084 -j DNAT --to 10.0.0.2
              ${iptables}/bin/iptables -t nat -D PREROUTING -p tcp --dst 100.114.224.96 --dport 8084 -j DNAT --to 10.0.0.2
              ${iproute2}/bin/ip link del veth0
              ${iproute2}/bin/ip -n mullvad rule del not fwmark 1 table 2468
              ${iproute2}/bin/ip -n mullvad link del wg0
              ${iproute2}/bin/ip link del wg0
            '';
        };
      };
    };
}
