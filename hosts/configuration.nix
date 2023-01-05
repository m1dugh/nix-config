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
        midugh-raspberrypi.home raspi
        '';

    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "altgr-intl";
        xkbOptions = "nodeadkeys";

        libinput = {
            enable = true;
            mouse.naturalScrolling = false;
            touchpad.naturalScrolling = false;
        };
    };


    services.printing.enable = true;
    services.blueman.enable = true;

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
        TERMINAL = "ALACRITTY";
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