{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.midugh.sway;
  menu = "${getExe pkgs.rofi} -modi drun,run -show drun";
in
{
  options.midugh.sway = {
    enable = mkEnableOption "sway config";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      alacritty
    ];

    home.file.".config/swaylock/config" = {
        text = ''
        image=${../../wallpapers/300SL.png}
        '';
    };

    midugh.rofi.enable = true;
    midugh.i3status-rust.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        terminal = lib.getExe pkgs.alacritty;
        modifier = "Mod4";
        gaps.outer = 5;
        gaps.inner = 10;
        fonts = {
          names = [ "DejaVu Sans Mono" ];
          style = "Bold Semi-Condensed";
          size = 11.0;
        };

        input."*" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
          xkb_options = "caps:swapescape";
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
          "${modifier}+d" = ''exec "${menu}"'';
          "${modifier}+r" = "mode resize";
          "${modifier}+Tab" = ''exec "${lib.getExe pkgs.swaylock}"'';
        };

        bars = [{
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          position = "top";
          trayOutput = "primary";

          fonts = {
            names = [ "FiraSans" "Pango" ];
            style = "Bold Semi-Condensed";
            size = 14.0;
          };
        }];
      };

      extraConfig = ''
        set $opacity 0.9
        for_window [class=".*"] opacity $opacity
        for_window [app_id=".*"] opacity $opacity

        default_border none
        for_window [class="^.*"] border pixel 2
      '';

    };
  };
}
