{ 
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    settings = {
      http = {
        address = "127.0.0.1:3003";
      };
      dns = {
        upstream_dns = [
          "9.9.9.9#dns.quad9.net"
        ];
      };
    };
  };
}
