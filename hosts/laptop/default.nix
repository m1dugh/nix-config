{
    config,
    pkgs,
    ...
}:
let
    lock_command = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
in {

    imports = [(import ./hardware-configuration.nix)];

    security.pki.certificateFiles = [
        ../../certs/le-maker.fr.pem
    ];

    boot.kernelModules = ["kvm-intel"];
    boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
            useOSProber = true;
            efiSupport = true;
            device = "nodev";
        };
    };

    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = ["midugh"];

    hardware = {
        opengl.enable = true;
        nvidia = {
            prime = {
                sync.enable = true;
                offload.enable = false;
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
            };
            powerManagement.enable = true;
        };

    };

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
        docker-compose
        kubectx
        kubernetes-helm
        terraform

        globalprotect-openconnect
        alacritty
    ];

    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "altgr-intl";
        xkbOptions = "nodeadkeys,caps:swapescape";

        displayManager.defaultSession = "xfce+i3";
        desktopManager = {
            xterm.enable = false;
            xfce = {
                enable = true;
                noDesktop = true;
                enableXfwm = false;
                enableScreensaver = false;
            };
        };
        
        windowManager.i3 = {
            enable = true;
            extraPackages = with pkgs; [
                betterlockscreen
                i3status
            ];
        };

        libinput = {
            enable = true;
            mouse.naturalScrolling = false;
            touchpad.naturalScrolling = false;
            touchpad.accelSpeed = "-0.2";
        };
        videoDrivers = ["nvidia"];
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
        nssmdns = true;
        openFirewall = true;
    };


    # GPG keys setup.
    services.pcscd.enable = true;
    programs.gnupg.agent = {
        enable = true;
        pinentryFlavor = "curses";
        enableSSHSupport = true;
    };

    programs.xss-lock = {
        enable = true;
        lockerCommand = "${lock_command}";
    };

    networking.resolvconf.dnsExtensionMechanism = false;
}
