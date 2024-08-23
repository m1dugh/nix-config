{ username
, config
, options
, pkgs
, stateVersion
, lib
, ...
}:
let
  lockCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
in
{

  imports = [
    ./hardware-configuration.nix
  ];

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
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
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
    arandr
    openssl
    yq
    jq
    bear

    networkmanagerapplet
  ];

  services.libinput = {
    enable = true;
    mouse.naturalScrolling = false;
    touchpad.naturalScrolling = false;
    touchpad.accelSpeed = "-0.2";
  };

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

  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [ ]);

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${lockCommand}";
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
}
