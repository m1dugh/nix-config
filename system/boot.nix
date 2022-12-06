{ config, ... }:

{
    boot.kernelParams = ["acpi_osi=!" "acpi_osi='Windows" "2009'" "splash"];
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
