{ username
, config
, pkgs
, stateVersion
, lib
, pkgs-local
, dragon-center-pkgs
, ...
}:
{

  imports = [
    ./hardware-configuration.nix
    ./firefox.nix
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
    package = dragon-center-pkgs.dragon-center;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
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
      ExecStart = "${lib.getExe pkgs.swaylock-effects} -f";
    };
    wantedBy = [ "lock.target" ];
  };

  networking.hostName = "midugh-laptop";
  networking.useDHCP = lib.mkDefault true;
  networking.extraHosts = ''
    127.0.0.1 *.localhost
  '';

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
      "video"
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

  xdg.mime.defaultApplications =
    (lib.attrsets.genAttrs [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "text/html"
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/xhtml+xml"
      "application/x-extension-xhtml"
      "application/x-extension-xht"
    ]
      (_: "firefox.desktop"));

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = 0;
  };

  boot.plymouth.enable = true;

  programs.virt-manager.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

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

  hardware.bluetooth.enable = true;

  security.pki.certificateFiles = [
    ../../certs/sncf.fr.pem
  ];

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

  environment.systemPackages = (with pkgs; [

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
    fzf
    stern
    kubernetes-helm
    terraform
    sops
    wireguard-tools
    age

    openconnect
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
    unzip
    ltrace
    nix-index

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

    nixfmt-rfc-style
    nixpkgs-review
    pavucontrol
  ]) ++ (with pkgs-local; [
    globalprotect-openconnect_2
  ]);

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
      swayidle
    ];
  };

  system.stateVersion = stateVersion;
  networking.resolvconf.dnsExtensionMechanism = false;

  services.logind.extraConfig = ''
    HandleSuspendKey=hibernate
    HandleLidSwitch=hibernate
    HandlePowerKey=ignore
  '';

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
  };
}
