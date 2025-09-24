{
  description = "My home server NixOS flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        glutesha-server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
	    ./media/jellyfin.nix
            ./configuration.nix
          ];
        };
      };
    };
}
