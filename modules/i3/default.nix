{ config
, lib
, pkgs
, ...
}:
with lib;
let cfg = config.midugh.i3;
in {
  options.midugh.i3 = {
    enable = mkEnableOption "i3";
    modifier = mkOption {
      type = types.str;
      default = "Mod4";
      description = "The modifier for i3";
      example = "Mod1";
    };

    screenshotCommand = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The command for screenshot";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.i3-gaps;
      example = pkgs.i3;
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        flameshot
        i3status-rust
        feh
        picom
        xorg.setxkbmap
        betterlockscreen
        alacritty
      ];
    };

    lockCommand = mkOption {
      type = types.str;
      default = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
      example = "${pkgs.i3lock}/bin/i3lock";
      description = "The lock command";
    };

    dmenuCommand = mkOption {
      type = types.str;
      default = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
      example = "${pkgs.dmenu}/bin/dmenu_run";
      description = "The dmenu command";
    };

    terminal = mkOption {
      type = types.str;
      default = "${pkgs.alacritty}/bin/alacritty";
      description = "The default command for terminal";
    };

    statusCommand = mkOption {
      type = types.str;
      default = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
      description = "The default status command";
    };

    wallpaper = mkOption {
      type = types.nullOr types.path;
      description = "The wallpaper image";
      default = null;
    };

    swapEscape = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to swap caps with escape";
    };
  };

  config = mkIf cfg.enable {
    home.packages = cfg.extraPackages;
    xsession.windowManager.i3 = {
      enable = true;
      package = cfg.package;
      config =
        let inherit (cfg) terminal modifier;
        in {
          inherit terminal modifier;
          gaps = {
            outer = 5;
            inner = 10;
          };
          fonts = {
            names = [ "DejaVu Sans Mono" ];
            style = "Bold Semi-Condensed";
            size = 11.0;
          };

          keybindings = mkOptionDefault {
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
            "XF86AudioMicMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
            "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
            "XF86AudioNext" = "exec --no-startup-id playerctl next";
            "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
            "${modifier}+Control+Shift+Right" = "move workspace to output right";
            "${modifier}+Control+Shift+Left" = "move workspace to output left";
            "${modifier}+Control+Shift+Up" = "move workspace to output up";
            "${modifier}+Control+Shift+Down" = "move workspace to output down";

            "${modifier}+l" = "exec ${cfg.lockCommand}";
            "${modifier}+d" = ''exec "${cfg.dmenuCommand}"'';
            "${modifier}+r" = "mode resize";
            "${modifier}+BackSpace" = ''exec "pkill -u $USER"'';
            "Print" = if (cfg.screenshotCommand != null) then "exec ${cfg.screenshotCommand}" else null;
          };

          bars = [{
            inherit (cfg) statusCommand;
            position = "top";
            trayOutput = "primary";

            fonts = {
              names = [ "FiraSans" "Pango" ];
              style = "Bold Semi-Condensed";
              size = 14.0;
            };
          }];

          startup = [
            (mkIf (cfg.wallpaper != null) {
              command = "${pkgs.feh}/bin/feh --bg-scale ${cfg.wallpaper}";
              always = true;
              notification = true;
            })
            {
              command = "exec ${pkgs.picom}/bin/picom";
              always = true;
            }

            (mkIf cfg.swapEscape {
              command = ''${pkgs.xorg.setxkbmap}/bin/setxkbmap -option "caps:swapescape"'';
              always = true;
            })
          ];
        };

      extraConfig = ''
        for_window [class="^.*"] border pixel 2
      '';
    };

    services.screen-locker = {
      enable = true;
      lockCmd = cfg.lockCommand;
    };
  };
}
