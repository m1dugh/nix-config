{ config, lib, ... }:

{
    specialisation.external-display.configuration = {
        system.nixos.tags = ["external-display"];
        hardware.nvidia = {
            prime = {
                sync.enable = true;
                nvidiaBusId = "PCI:1:0:0";
                intelBusId = "PCI:0:2:0";
                offload.enable = lib.mkForce false;
            };
            powerManagement.enable = lib.mkForce false;
        };
        services.xserver.videoDrivers = lib.mkForce ["nvidia"];
    };
}
