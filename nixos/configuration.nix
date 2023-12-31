# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>  # This is done through a flake now I think...
    ];


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # flakes stuff from Isaac
  nix = {
  package = pkgs.nixFlakes;
  extraOptions = "experimental-features = nix-command flakes";
  };

  # bootloader from Isaac
  # boot.loader.svstemd-boot.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Shel added this for vscode to run:
	nixpkgs.config.allowUnfree = true;

  # programs.git ={
  # enable = true;
  # userName = "mrVeganProgrammerGuyDude";

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11 (this is the old one that works)
 # services.xserver = {
 #   layout = "us";
 #   xkbVariant = "";
 # };

# Neew stuff from https://blog.neerajadhav.in/how-to-install-i3wm-on-nixos-a-step-by-step-guide
  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+i3";
      };
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

 programs.zsh.enable = true; # I needed this line, even though it seems to be in the zsh config file.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheltronmini = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "SheltronMini";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      git
      vscode
      keepassxc
      # dropbox
      signal-desktop
      discord
      ksnip
      vlc
      obs-studio
      slack
      mongodb-compass
      zoom-us
      gimp
      gh # Github
    #  thunderbird
	gnome.gnome-keyring  # This was to try and get i3 going somehow...
    ];
  };

  # Home manager stuff from here: https://nix-community.github.io/home-manager/
#   home-manager.useUserPackages = true; # This was an optional feature from nix-community.github
#   home-manager.useGlobalPkgs = true; # This was an optional feature from nix-community.github
#   home-manager.users.sheltronmini = { pkgs, ... }: {
#   home.stateVersion = "23.05"; # Had to add this line from issue 4433 in github 
#   home.packages = [ pkgs.atool pkgs.httpie ];
#   programs.bash.enable = true;
# };

# stuff from tech.aufomm on home manager setup

# I think all the home manager stuff is done with flakes now...
# home-manager = {
#     useGlobalPkgs = true;
#     useUserPackages = true;
#     users.sheltronmini = import ./home.nix;
#   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [];  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  environment.shells = with pkgs; [zsh];
  #  wget
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
