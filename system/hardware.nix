{ config, ... }:

{
    virtualisation.docker = {
        enable = true;
        daemon.settings = {
            features.buildkit = true;
        };
    };

    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    users.extraGroups.vboxusers.members = ["midugh"];
# Enable sound.
    sound.enable = true;
    hardware = {
        bluetooth.enable = true;
        pulseaudio.enable = true;
        opengl.enable = true;
        nvidia = {
            prime = {
                sync.enable = true;
                offload.enable = false;
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
            };
            powerManagement.enable = false;
        };

    };
}
