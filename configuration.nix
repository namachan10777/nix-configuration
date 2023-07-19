# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:
let nmpkgs = import ./pkgs/default.nix; in
let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];
  nix.settings.experimental-features = [ "nix-command" ];
  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  systemd.services.lemurs = {
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
      "getty@tty2.service"
    ];
    environment = {
      RUST_LOG = "Trace";
      PWD = "/var/lib/lemurs";
    };
    serviceConfig = {
      ExecStart = "${nmpkgs.lemurs}/bin/lemurs --config ${nmpkgs.lemurs}/etc/lemurs/config.toml";
      WorkingDirectory = "/var/lib/lemurs";
      StandardInput = "tty";
      TTYPath = "/dev/tty2";
      TTYReset = "yes";
      TTYVHangup = "yes";
      Type = "idle";
    };
    aliases = [ "display-manager.service" ];
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/lemurs 0755 root root"
  ];
  systemd.services.cloudflared_ssh = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run home";
      Restart = "on-failure";
      RestartSec = "5s";
      User = "cloudflared";
    };
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  systemd.network = {
    enable = true;
    networks = {
      "enp11s0f1" = {
        matchConfig.name = "enp11s0f1";
        networkConfig.DHCP = "yes";
        networkConfig.MulticastDNS = "yes";
      };
    };
  };

  networking.hostName = "sakanainu"; # Define your hostname.

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "solar24x32";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  # Disable all display manager manually.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.printing.enable = true;
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  users.groups.lemurs.gid = 400;
  users.users = {
    namachan = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      initialPassword = "pw123";
    };
    cloudflared = {
      home = "/var/lib/cloudflared";
      createHome = true;
      isSystemUser = true;
      group = "cloudflared";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    nmpkgs.lemurs
    pkgs.home-manager
    pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.fish
    pkgs.gnumake
    pkgs.wget
    pkgs.gcc
    pkgs.clang
    pkgs.ninja
    pkgs.skim
    pkgs.ghq
    pkgs.mold
    pkgs.go
    pkgs.lazygit
    pkgs.git
    pkgs.starship
    pkgs.python3
    pkgs.gnum4
    pkgs.automake
    pkgs.autoconf
    pkgs.libtool
    pkgs.cloudflared
    pkgs.lldb
    pkgs.protobuf
    pkgs.nodejs
    pkgs.file
    pkgs.rustup
    pkgs.alacritty # gpu accelerated terminal
    dbus-sway-environment
    configure-gtk
    pkgs.wayland
    pkgs.xdg-utils # for opening default programs when clicking links
    pkgs.glib # gsettings
    pkgs.dracula-theme # gtk theme
    pkgs.gnome3.adwaita-icon-theme # default gnome cursors
    pkgs.swaylock
    pkgs.swayidle
    pkgs.grim # screenshot functionality
    pkgs.slurp # screenshot functionality
    pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    pkgs.bemenu # wayland clone of dmenu
    pkgs.mako # notification system developed by swaywm maintainer
    pkgs.wdisplays # tool to configure displays
  ];



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
  services.vscode-server.enable = true;

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  security.polkit.enable = true;
  security.pam.services = {
    lemurs.text = ''
      auth        substack   login
      account     include    login
      password    substack   login
      session     include    login
    '';
  };
}

