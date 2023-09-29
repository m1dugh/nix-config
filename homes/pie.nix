{
  config,
  pkgs,
  home-manager,
  username,
  lib,
  ...
}@inputs:
let
    configRoot = "../../configs";
    i3-mod = "Mod4";
    dmenu_command = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
    lock_command = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
    wallpaper = ../wallpapers/prologin-2023_wallpaper.png;
    lockscreen = ../wallpapers/archwave.png;
in {

  fonts.fontconfig.enable = true;

  manual.manpages.enable = false;
  home.username = "romain.le-miere";
  home.homeDirectory = "/home/romain.le-miere";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    cargo
    betterlockscreen
    go
    picom
    alacritty
    i3-gaps
    imagemagick

    # fonts
    font-awesome_6
    material-symbols
  ];

  programs.i3status-rust = {
    enable = true;
    bars.default = {
        blocks = [
            {
                block = "cpu";
                interval = 1;
            }
            {
                block = "memory";
                interval = 1;
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
                block = "time";
                interval = 1;
            }
        ];

        settings = {
            theme = {
                theme = "solarized-dark";
                overrides = {
                    separator = "";
                };
            };
        };
        icons = "awesome6";
        theme = "gruvbox-dark";
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
        modi = "calc,drun,ssh";
    };

    theme = "themes/midugh-custom";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.packer-nvim
    ];
  };

  programs.home-manager.enable = true;

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
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export SHELL=zsh;
    '';
  };

  programs.alacritty = {
    enable = true;
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        config = {
            modifier = "${i3-mod}";
            terminal = "${pkgs.alacritty}/bin/alacritty";

            gaps = {
                inner = 10;
                outer = 5;
            };

            keybindings =
            let
            inherit (config.xsession.windowManager.i3.config) modifier;
            in lib.mkOptionDefault {
                "${modifier}+d" = ''exec "${dmenu_command}"'';
                "${modifier}+l" = ''exec "${lock_command}"'';
                "${modifier}+r" = "mode resize";
                "${modifier}+BackSpace" = ''exec "pkill -u $USER"'';
            };

            bars = [{
                statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
                position = "top";
                trayOutput = "primary";

                fonts = {
                    names = ["FiraSans" "Pango"];
                    style = "Bold Semi-Condensed";
                    size = 13.0;
                };
            }];

            startup = [
            {
                command = "${pkgs.picom}/bin/picom";
            }
            {
                command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
                always = true;
                notification = true;
            }
            {
                command = "${pkgs.betterlockscreen} -u ${lockscreen}";
            }];
        };

        extraConfig = ''
            for_window [class="^.*"] border pixel 2
        '';

    };
  };

  home.file = {
    ".vimrc".source = ./. + "${configRoot}/vimrc";
    ".config/nvim" = {
      recursive = true;
      source = ./. + "${configRoot}/nvim";
    };

    ".config/alacritty" = {
        recursive = true;
        source = ./. + "${configRoot}/alacritty";
    };
    ".config/rofi" = {
        recursive = true;
        source = ./. + "${configRoot}/rofi";
    };
  };
}
