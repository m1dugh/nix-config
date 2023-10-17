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

            bars = [{
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
                position = "top";
                trayOutput = "primary";

                fonts = {
                    names = ["FiraSans" "Pango"];
                    style = "Bold Semi-Condensed";
                    size = 14.0;
                };
            }];

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
        enable = true;
        lockCmd = "${lock_command}";
    };

    services.ssh-agent.enable = true;

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

    programs.git = {
        enable = true;
        userName = "m1dugh";
        userEmail = "romain.le-miere@epita.fr";

        extraConfig = {
            init.defaultBranch = "master";
            pull.rebase = true;
            core.editor = "nvim";
            push.autoSetupRemote = true;
        };
    };

      programs.i3status-rust = {
        enable = true;
        bars.default = {
            blocks = [
                {
                    block = "battery";
                    format = " $icon $percentage $time ";
                }
                {
                    block = "cpu";
                    interval = 1;
                }
                {
                    block = "memory";
                    interval = 1;
                    format = " $icon $mem_used.eng(prefix:Mi)/$mem_total.eng(prefix:Mi)($mem_used_percents.eng(w:2)) ";
                }
                {
                    block = "disk_space";
                    path = "/";
                    info_type = "available";
                }
                {
                    block = "load";
                    interval = 1;
                    format = " $icon $1m ";
                }
                {
                    block = "sound";
                    click = [{
                        button = "left";
                        cmd = "pavucontrol";
                    }];
                }
                {
                    block = "custom";
                    interval = 1;
                    command = ''date "+%a %d/%m %H:%M:%S"'';
                }
            ];

            settings = {
                theme = {
                    theme = "solarized-dark";
                };
            };
            icons = "awesome6";
            theme = "gruvbox-dark";
        };
      };

    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
            ];
            theme = "robbyrussell";
        };

        history = 
        let history_size = 100000;
        in {
            size = history_size;
            save = history_size;
        };

        initExtra = ''
            if (( $+commands[kubectl] )); then
                # If the completion file doesn't exist yet, we need to autoload it and
                # bind it to `kubectl`. Otherwise, compinit will have already done that.
                if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubectl" ]]; then
                  typeset -g -A _comps
                  autoload -Uz _kubectl
                  _comps[kubectl]=_kubectl
                fi

                kubectl completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_kubectl" &|
            fi
            '';
        shellAliases = {
            k = "kubectl";
        };
    };

    programs.home-manager.enable = true;

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
    };

}
