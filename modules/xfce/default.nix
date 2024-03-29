{
    lockCommand,
    screenshotCommand,
    layout ? "us",
    xkbVariant ? "altgr-intl",
    xkbOptions ? "nodeadkeys,caps:swapescape",
    defaultSession ? "xfce+i3",
}:
{
    pkgs,
    ...
}:
{
    environment.systemPackages = with pkgs; [
        betterlockscreen
    ];

    services.xserver = {
        xkb = {
            inherit layout;
            options = xkbOptions;
            variant = xkbVariant;
        };
        enable = true;

        displayManager.defaultSession = defaultSession;
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
        };
    };
}
