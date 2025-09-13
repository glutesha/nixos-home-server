{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "glutesha-server"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  environment.systemPackages = with pkgs; [
      vim 
      wget
      docker
      git
      btop
      fastfetch
      cowsay
      usbutils
      minicom
      python3
      nvidia-container-toolkit
  ];
  
  # Docker
  virtualisation.docker.daemon.settings.features.cdi = true;
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 8080 8443 443 ];
  system.stateVersion = "25.05"; 

  # Stop hybernation
  systemd.targets.sleep.enable = false;
  systemd.targets.hybernate.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable sudo && add me
  users.users.glutesha = {
   isNormalUser = true;
   extraGroups = [ "wheel" "docker" ];
   openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBKMk8rlA0M7D5cdtoFUci4M4UI+nI6Dd772lk5kmLK glutesha@glutesha-laptop.local" ]; 
  };
  security.sudo = {
   wheelNeedsPassword = true;
   extraRules = [{
     groups = [ "wheel" ];
     commands = [
       {
        command = "ALL";
        options = [ "NOPASSWD" ];
       }
     ];
    }
   ];
  };

  # Enable avahi
  services.avahi = {
   enable = true;
   publish = {
    enable = true;
    addresses = true;
    workstation = true;
  };
 };
 

 # Enable synology auto mount
 fileSystems."/mnt/nas_video" = {
   device = "//192.168.1.69/video";
   fsType = "cifs";
   options = [
     "credentials=/etc/nixos/smb-credentials"
     "uid=1000"
     "gid=100"  
     "iocharset=utf8"
     "vers=3.0"
     "nofail"
     "_netdev"
   ];
 };
 # NVIDIA stuff
 services.xserver.videoDrivers = [ "nvidia" ];
 hardware.graphics.enable = true;

 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "nvidia-x11" "nvidia-settings" ];
 
 hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;      
    powerManagement.enable = true; 
 };

 hardware.nvidia-container-toolkit.enable = true;

 # Autologin on my small display
 systemd.services."getty@tty1".enable = true;
 systemd.services."getty@tty1".serviceConfig.ExecStart = [
   "/usr/bin/agetty"
   "--autologin" "glutesha"
   "--noclear"
   "%I"
   "$TERM"
 ];

 services.getty = {
   autologinUser = "glutesha"; 
 };
}

