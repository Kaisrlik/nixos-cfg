# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  nix = {
    # package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
  imports =
    [ # Include the results of the hardware scan.
      ./machine/intel/hardware-configuration.nix
      ./modules/mail.nix
    ];

  # nixpkgs.config.allowUnfree = true;

  boot.supportedFilesystems = [ "ext4" ];
  boot.loader = {
    # systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    # Use the GRUB 2 boot loader.
    grub = {
      enable = true;
      efiSupport = true;
      # boot is located on encrypted partition
      # efiInstallAsRemovable = true;
      # Define on which hard drive you want to install Grub.
      device = "nodev"; # or "nodev" for efi only
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # links /libexec from derivations to /run/current-system/sw
  environment.pathsToLink = [ "/libexec" ];

#   services.xserver = {
#     enable = true;
#     # Configure keymap in X11
#     layout = "us";
#     xkbOptions = "eurosign:e";
#
#     desktopManager = {
#       xterm.enable = false;
#     };
#     displayManager = {
#       defaultSession = "none+i3";
#     };
#
#     windowManager.i3 = {
#       enable = true;
#       extraPackages = with pkgs; [
#         dmenu
#         i3blocks
#         i3lock
#       ];
#     };
#     # Enable touchpad support (enabled default in most desktopManager).
#     libinput.enable = true;
#   };

  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbOptions = "eurosign:e";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };
  # services.gnome3.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      bemenu
      i3blocks
      mako # notification daemon
      sysstat # cpu_stats script
      slurp grim # screen capturing
    ];
  };

  xdg.portal = {
    enable = true;
    # enable share sreen
    wlr.enable = true;
    extraPortals = with pkgs; [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  security.polkit.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jkaisrli = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" "disk" "input" "video" "network" "audio" ]; # Enable ‘sudo’ for the user.
  };

  users.users.root = {
    shell = pkgs.zsh;
  };


  # enabled in later version
  # nixpkgs.overlays = [ (self: super: {
  #   isync = super.isync.override { withCyrusSaslXoauth2 = true; };
  # })];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    ccls
    ctags

    foot
    git
    tig
    lnav
    ltex-ls
    zsh
    fzf
    shellcheck

    # nix specific
    home-manager
    direnv

    gnumake
    cmake
    meson
    ninja
    gcc
    jq

    (import ./pkgs/impressive { inherit pkgs; })
    evince
    vlc
    lynx # html/text

    # email
    notmuch
    neomutt
    abook

    libnotify
    curl
    firefox-wayland
    perl # required by some i3 scripts
    # required by nvim and other tools
    (python3.withPackages (p: with p; [
      # impressive dep
      pillow pygame
    ]))
    bash
    acpi # see battery status
    pavucontrol

    # vpn, certs, proxies
    cacert
    keychain
    netcat-openbsd
    openconnect
    openssl # expiration of certs
    pinentry-curses # gpg requires

    # windows rdp
    remmina

    man-pages
    man-pages-posix
  ];

  # libraries and dev utils may provide additional documentation/man-pages
  documentation.dev.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "slack"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "teams"
      "discord"
  ];

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      slack = "${pkgs.slack}/bin/slack";
      spotify = "${pkgs.spotify}/bin/spotify";
      # teams = "${pkgs.teams}/bin/teams";
    };
  };

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  # Additionally, link to pinentry has to exists
  # $ cat ~/.gnupg/gpg-agent.conf
  # pinentry-program /run/current-system/sw/bin/pinentry
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.startAgent = true;

  programs.zsh.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
  };
  services.pipewire.enable = true;
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
  };

  # Enable the networkmanager deamon
  networking.networkmanager.enable = true;
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
  system.stateVersion = "23.05";
}
