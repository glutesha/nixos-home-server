# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "glutesha-server"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
		  
  # Stop hybernation
  systemd.targets.sleep.enable = false;
  systemd.targets.hybernate.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable sudo && add me
  users.users.glutesha = {
   isNormalUser = true;
   extraGroups = [ "wheel" "docker" ];
   openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFIf4S05G1kDSK/Ltwhhap3ySO3eAziQ8fFBM53mN2K glutesha@MacBook-Air-Vladislav.local" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBKMk8rlA0M7D5cdtoFUci4M4UI+nI6Dd772lk5kmLK glutesha@glutesha-laptop.local" ];
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
 

 # Enable synology
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
 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["nvidia-x11" "nvidia-persistenced" "nvidia-settings"];

 services.xserver.videoDrivers = [ "nvidia" ];
 hardware.graphics.enable = true;

 hardware.nvidia = {
    open = false;
    modesetting.enable = true;      
    powerManagement.enable = true; 
    nvidiaPersistenced = true;   
    package = config.boot.kernelPackages.nvidiaPackages.stable;
 };

 hardware.nvidia-container-toolkit.enable = true;
 boot.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_modeset" "nvidia_drm" ];
 boot.blacklistedKernelModules = [ "nouveau" ];
}

