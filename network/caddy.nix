{
  services.caddy = {
    enable = true;

    virtualHosts.":80/jellyfin" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:8096
      '';
    };

  };
}
