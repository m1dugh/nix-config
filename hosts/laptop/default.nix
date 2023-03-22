{
    config,
    pkgs,
    ...
}:

{

    imports = [(import ./hardware-configuration.nix)];

    boot.kernelModules = ["kvm-intel"];
    boot.loader = {
        efi.canTouchEfiVariables = true;
        grub = {
            version = 2;
            useOSProber = true;
            efiSupport = true;
            device = "nodev";
        };
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/788a4db7-36a4-40cb-9584-e7f63e4df148";
        fsType = "ext4";
    };

    fileSystems."/home/midugh/Documents" = {
        device = "/dev/disk/by-uuid/761dc816-7bf0-4436-9692-f30db0ac35c3";
        fsType = "ext4";
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
    ];

    services.xserver = {
        videoDrivers = ["nvidia"];
        libinput.touchpad.accelSpeed = "-0.2";
    };
}
