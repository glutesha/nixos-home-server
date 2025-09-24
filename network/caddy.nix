{
  services.caddy = {
    enable = true;

    virtualHosts.":80" = {
      extraConfig = ''
	redir /jellyfin /jellyfin/

	handle_path /jellyfin/* {
          reverse_proxy 127.0.0.1:8096
	}
      '';
    };

  };
}
