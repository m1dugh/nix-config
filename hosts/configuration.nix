{
    config,
    pkgs,
    username,
    ... 
}:

{
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Europe/Paris";

    networking.networkmanager.enable = true;
    networking.extraHosts = 
        ''
        midugh-raspberrypi raspi
        '';

    nix.settings.experimental-features = ["nix-command" "flakes"];

    nixpkgs.config.pulseaudio = true;

    environment.systemPackages = with pkgs; [
        git
        vim
        zsh

        python311
        poetry

        wget
        curl
        xorg.xkill
        htop
        pciutils
    ];

    programs.zsh.enable = true;

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

    system.stateVersion = "23.11";
}
