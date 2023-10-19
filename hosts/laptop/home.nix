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
        (import ../../modules/zsh {
            withKubernetes = true;  
        })
        (import ../../modules/i3 {
            inherit lockCommand dmenuCommand wallpaper terminal;
            i3pkg = pkgs.i3-gaps;
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        })
        ../../modules/alacritty
        ../../modules/i3status-rust
        (import ../../modules/rofi {
            inherit terminal;
        })
        (import ../../modules/git {
            userName = "m1dugh";
            userEmail = "romain.le-miere@epita.fr";
        })
    ];
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
