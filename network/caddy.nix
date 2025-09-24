{
  services.caddy = {
    enable = true;
    virtualHosts."http://glutesha.local/jellyfin" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8096
      '';
    };
  };
}
