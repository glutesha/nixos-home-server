{
  services.caddy = {
    enable = true;
    virtualHosts."glutesha.local/jellyfin" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8096
      '';
      enableTLS = false;
    };
  };
}
