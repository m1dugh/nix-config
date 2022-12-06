{ config, pkgs, ... }:

{
# Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "altgr-intl";
        xkbOptions = "nodeadkeys";
        displayManager.defaultSession = "xfce+i3";
        videoDrivers = ["modesetting"];
        desktopManager = {
            xterm.enable = false;
            xfce = {
                enable = true;
                noDesktop = true;
                enableXfwm = false;
            };
        };

        windowManager.i3 = {
            enable = true;
            package = pkgs.i3-gaps;
            extraPackages = with pkgs; [
                dmenu
                i3lock
                i3status
            ];
        };

# Enable touchpad support (enabled default in most desktopManager).
        libinput = {
            enable = true;
            touchpad.naturalScrolling = false;
            mouse.naturalScrolling = false;
        };
    };
}
