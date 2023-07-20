{
    pkgs,
    home-manager,
    config,
    lib,
    ...
}:
let
    config-root = "../../../configs";
    i3-mod = "Mod4";
    wallpaper = ../../wallpapers/wallpaper.jpg;
    dmenu_command = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
    lock_command = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
in {
    home = {
        packages = with pkgs; [
            krb5
            sshfs

            poetry

            # LspServer
            rust-analyzer
            clang-tools

            flameshot

            discord
            teams
            slack

            brave
            firefox

            imagemagick
            feh
            xss-lock
            picom
        ];

        file = {
            ".vimrc".source = ./. + "${config-root}/vimrc";
            ".config/nvim" = {
                recursive = true;
                source = ./. + "${config-root}/nvim";
            };
            "gdbinit".source = ./. + "${config-root}/gdbinit";
            ".config/i3status/"= {
                recursive = true;
                source = ./. + "${config-root}/i3status";
            };
            ".config/alacritty/"={
                recursive = true;
                source = ./. + "${config-root}/alacritty";
            };
            ".config/rofi/" = {
                source = ./. + "${config-root}/rofi";
                recursive = true;
            };
        };
    };

    xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        config = {
            modifier = "${i3-mod}";
            terminal = "${pkgs.alacritty}/bin/alacritty";

            gaps = {
                inner = 10;
                outer = 5;
            };

            fonts = {
                names = ["DejaVu Sans Mono"];
                style = "Bold Semi-Condensed";
                size = 11.0;
            };

            keybindings = 
                let modifier = config.xsession.windowManager.i3.config.modifier;
            in lib.mkOptionDefault {
# Sound keybinds
                "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status";
                "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status";
                "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
                "XF86AudioMicMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
                "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
                "XF86AudioNext" = "exec --no-startup-id playerctl next";
                "XF86AudioPrev" = "exec --no-startup-id playerctl previous";

# Workspaces moves
                "${modifier}+Control+Shift+Right" = "move workspace to output right";
                "${modifier}+Control+Shift+Left" = "move workspace to output left";
                "${modifier}+Control+Shift+Up" = "move workspace to output up";
                "${modifier}+Control+Shift+Down" = "move workspace to output down";

                "${modifier}+l" = "exec ${lock_command}";
                "${modifier}+d" = ''exec "${dmenu_command}"'';
                "${modifier}+r" = "mode resize";
            };

            bars = [
            {
                statusCommand = "${pkgs.i3status}/bin/i3status";
                position = "top";
                trayOutput = "primary";
                fonts = {
                    names = ["FiraSans" "pango"];
                    style = "Bold Semi-Condensed";
                    size = 11.0;
                };
            }
            ];

            startup = [
            {
                command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
                always = true;
                notification = false;
            }
            ];

            workspaceOutputAssign = [
            {
                workspace = "1";
                output = "eDP-1-1";
            }
            {
                workspace = "2";
                output = "HDMI-0";
            }
            ];
        };
        extraConfig = ''
            for_window [class="^.*"] border pixel 2
            '';
    };

    services.screen-locker = {
        lockCmd = "${lock_command}";
    };

    programs.rofi = {
        enable = true;
        terminal = "${pkgs.alacritty}/bin/alacritty";
        extraConfig = {
            modi = "calc,drun,ssh";
        };
        theme = "themes/midugh-custom";
    };


    xfconf.settings = {
        xfce4-session = {
            "general/LockCommand" = "${lock_command}";
        };
        xfce4-keyboard-shortcuts = {
            "commands/custom/Print" = "${pkgs.flameshot}/bin/flameshot gui";
        };
    };
}
