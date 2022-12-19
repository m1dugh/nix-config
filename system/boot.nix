{ config, ... }:

{

    boot.kernelModules = ["kvm-intel"];
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
        };
        grub = {
            version = 2;
            useOSProber = true;
            efiSupport = true;
            device = "nodev";
        };
    };
}
