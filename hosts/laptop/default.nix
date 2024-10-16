{ username
, config
, pkgs
, stateVersion
, lib
, ...
}:
{

  imports = [
    ./hardware-configuration.nix
  ];

  fonts.packages = with pkgs; [
    fira-code
    (nerdfonts.override {
      fonts = [
        "FiraCode"
      ];
    })
  ];

  services.msi-dragon-center = {
    enable = true;
    driver = {
      enable = true;
      package = pkgs.msi-ec;
    };
  };

  users.extraGroups.dragon-center.members = [ username ];

  # for loginctl lock-session
  services.systemd-lock-handler.enable = true;

  systemd.user.services.loginctl-swaylock = {
    enable = true;
    description = "A service locking screen";
    onSuccess = [ "unlock.target" ];
    partOf = [ "lock.target" ];
    after = [ "lock.target" ];
    serviceConfig = {
      Type = "forking";
      Restart = "on-failure";
      RestartSec = 0;
      ExecStart = "${lib.getExe pkgs.swaylock} -f";
    };
    wantedBy = [ "lock.target" ];
  };

  networking.hostName = "midugh-laptop";
  networking.useDHCP = lib.mkDefault true;

  users.groups.${username} = {
    members = [ username ];
    gid = 1000;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
      "kvm"
      "openrazer"
      config.users.groups.users.name
    ];
    shell = pkgs.zsh;
    uid = 1000;
    group = config.users.groups.${username}.name;
  };

  users.users."guest" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 5000;
    extraGroups = [
      config.users.groups.users.name
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
    ];
  };

  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "brave.desktop";
    "x-scheme-handler/https" = "brave.desktop";
    "text/html" = "brave.desktop";
    "application/x-extension-htm" = "brave.desktop";
    "application/x-extension-html" = "brave.desktop";
    "application/x-extension-shtml" = "brave.desktop";
    "application/xhtml+xml" = "brave.desktop";
    "application/x-extension-xhtml" = "brave.desktop";
    "application/x-extension-xht" = "brave.desktop";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  boot.plymouth.enable = true;

  virtualisation.virtualbox.host = {
    enable = false;
    enableExtensionPack = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  users.extraGroups.vboxusers.members = [ username ];
  users.extraGroups.libvirtd.members = [ username ];
  users.extraGroups.wireshark.members = [ username ];
  users.extraGroups.dialout.members = [ username ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features.buildkit = true;
    };
  };

  sound.enable = true;
  hardware.bluetooth.enable = true;

  security.rtkit.enable = true;

  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # Dev dependencies
    go

    rustc
    cargo

    nodejs
    yarn

    gcc
    gnumake
    gdb
    clang

    kubernetes
    krew
    docker-compose
    kubectx
    kubernetes-helm
    terraform
    sops
    wireguard-tools
    age

    globalprotect-openconnect
    alacritty

    btrfs-progs

    criterion

    wireshark

    libreoffice-qt6-fresh
    gimp
    burpsuite
    bruno
    git-lfs
    wdisplays
    openssl
    yq-go
    jq
    bear

    networkmanagerapplet
    glib

    # Games
    prismlauncher

    wl-clipboard-rs
    libinput

    teams-for-linux

    openrazer-daemon
    polychromatic

    awscli2
  ];

  services.displayManager =
    let
      sessions =
        let
          swaySession = pkgs.writeText "sway.desktop" ''
            [Desktop Entry]
            Name=Sway
            Comment=Wayland window manager
            Exec=sway
            Type=Application
          '';
        in
        pkgs.stdenv.mkDerivation {
          src = ./.;
          providedSessions = [
            "sway"
          ];
          name = "ly-sessions";
          configurePhase = ''
            mkdir -p $out/share/wayland-sessions/
          '';
          installPhase = ''
            cp ${swaySession} $out/share/wayland-sessions/sway.desktop
          '';
        };
    in
    {
      enable = true;
      sessionPackages = lib.lists.singleton sessions;
    };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nouveau" ];
    displayManager.gdm = {
      enable = true;
    };
  };

  services.blueman.enable = true;

  services.printing = {
    enable = true;
  };

  services.globalprotect = {
    enable = true;
    settings."sncf.gpcloudservice.com".openconnect-args = "--os win";
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };

  services.avahi = {
    enable = false;
    nssmdns4 = true;
    openFirewall = true;
  };


  # GPG keys setup.
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
    ];
  };

  system.stateVersion = stateVersion;
  networking.resolvconf.dnsExtensionMechanism = false;

  services.logind.extraConfig = ''
    HandleSuspendKey=hibernate
    HandleLidSwitch=hibernate
  '';

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
  };
}
