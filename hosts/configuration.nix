{
    config,
    pkgs,
    username,
    ... 
}:

{
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Europe/Paris";

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

    networking.networkmanager.enable = true;
    networking.extraHosts = 
        ''
        midugh-raspberrypi raspi
        '';

    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "altgr-intl";
        xkbOptions = "nodeadkeys";

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
        };
    };


    services.printing.enable = true;
    services.blueman.enable = true;

    # GPG keys setup.
    services.pcscd.enable = true;
    programs.gnupg.agent = {
        enable = true;
        pinentryFlavor = "curses";
        enableSSHSupport = true;
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    nixpkgs.config.pulseaudio = true;

    environment.systemPackages = with pkgs; [
        docker-compose
        git
        vim
        zsh
        alacritty

        alacritty
        gcc
        gnumake
        python310

        wget
        curl
        xorg.xkill
        htop
        pciutils

        pinentry-curses
    ];

    fonts.fonts = with pkgs; [
        fira-code
        fira-code-symbols
        noto-fonts
        noto-fonts-emoji
        liberation_ttf
    ];

    environment.shells = with pkgs; [zsh];

    environment.variables = {
        TERMINAL = "alacritty";
        EDITOR = "vim";
        VISUAL = "vim";
    };

    users.users.${username} = {
        isNormalUser = true;
        extraGroups = ["wheel" "docker" "networkmanager" "kvm"];
        shell = pkgs.zsh;
    };

    system.stateVersion = "22.11";
}
