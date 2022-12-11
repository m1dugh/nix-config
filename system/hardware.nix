{ config, ... }:

{
    virtualisation.docker.enable = true;
# Enable sound.
    sound.enable = true;
    hardware = {
        bluetooth.enable = true;
        pulseaudio.enable = true;
        opengl.enable = true;
        nvidia.prime = {
            offload.enable = true;
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };
    };
}
