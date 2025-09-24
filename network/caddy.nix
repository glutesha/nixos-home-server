{
  services.caddy = {
    enable = true;

    virtualHosts."http://127.0.0.1/jellyfin" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8096
      '';
    };

  };
}
