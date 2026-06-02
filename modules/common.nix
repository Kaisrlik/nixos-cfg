{ pkgs, ... }:
{
  nix = {
    # package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    settings.trusted-users = [ "@wheel" ];
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
    ripgrep

    file
    foot
    fzf
    git
    htop
    killall
    lnav
    ltex-ls
    nil
    shellcheck
    tree-sitter nodejs-slim
    tig
    tree
    zsh
    zathura # pdf browser
    unzip

    # nix specific
    home-manager
    direnv
    nix-tree

    gnumake
    cmake
    meson
    ninja
    gcc
    jq

    (callPackage ../pkgs/impressive { })
    vlc
    lynx # html/text

    # email
    notmuch
    neomutt
    abook

    curl
    rsync
    sshfs

    libnotify
    firefox
    perl # required by some i3 scripts
    # required by nvim and other tools
    (python3.withPackages (p: with p; [
      pynvim
      requests
    ]))
    bash
    acpi # see battery status
    alsa-utils # see sound status
    pavucontrol

    # vpn, certs, proxies
    cacert
    keychain
    netcat-openbsd
    openconnect
    openssl # expiration of certs

    # windows rdp
    remmina

    man-pages
    man-pages-posix
  ];
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

  fonts.packages = with pkgs; [
    intel-one-mono
    nerd-fonts.fira-code
  ];


  # links /libexec from derivations to /run/current-system/sw
  environment.pathsToLink = [ "/libexec" ];

  # services.gnome3.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  services.pipewire.audio.enable = true;

  users.users.root = {
    shell = pkgs.zsh;
  };

  # libraries and dev utils may provide additional documentation/man-pages
  documentation.dev.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "discord"
    "github-copilot-cli"
    "google-chrome"
    "slack"
    "spotify"
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
    "teams"
    "xnviewmp"
  ];

  # we have vim
  programs.nano.enable = false;
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      # slack = "${pkgs.slack}/bin/slack";
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
    pinentryPackage = pkgs.pinentry-curses;
  };
  # List services that you want to enable:

  programs.ssh.startAgent = true;
  programs.zsh.enable = true;

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
  system.stateVersion = "24.05";
}
