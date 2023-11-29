{
    pkgs,
    ...
}:
let
    wallpaper = ../../wallpapers/wallpaper.jpg;
    dmenuCommand = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
    lockCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    screenshotCommand = "${pkgs.flameshot}/bin/flameshot gui";
in {
    imports = [
        ../../modules/nvim
        ../../modules/zsh
        ../../modules/git 
        ../../modules/i3
        ../../modules/alacritty
        (import ../../modules/i3status-rust {
            battery = true;
            netDevice = "enp60s0";
        })
        (import ../../modules/rofi {
            inherit terminal;
        })
    ];

    midugh.i3 = {
        enable = true;
        inherit lockCommand dmenuCommand wallpaper terminal;
    };

    midugh.nvim.enable = true;
    midugh.zsh = {
        enable = true;
        withKubernetes = true;
    };
    midugh.git = {
        enable = true;
        editor = "nvim";
        username = "m1dugh";
        email = "romain.le-miere@epita.fr";
    };
    home = {
        packages = with pkgs; [
            krb5
            sshfs

            poetry

            # LspServer
            rust-analyzer
            clang-tools

            discord
            teams
            slack

            brave
            firefox

            imagemagick
        ];
    };

    xfconf.settings = {
        xfce4-session = {
            "general/LockCommand" = "${lockCommand}";
        };
        xfce4-keyboard-shortcuts = {
            "commands/custom/Print" = screenshotCommand;
        };
    };

    services.ssh-agent.enable = true;
    programs.home-manager.enable = true;
}
