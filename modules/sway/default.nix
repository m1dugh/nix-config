{ config
, rootPath
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
    wallpaper = mkOption {
      type = types.nullOr types.path;
      default = rootPath + "/wallpapers/wallpaper.jpg";
      description = "The path to the wall paper";
    };

    enableNetworkManager = mkEnableOption "network manager applet";

    volumeStep = mkOption {
      description = "The step the volume should be changed for the increase/decrease volume shortcut";
      type = types.int;
      default = 2;
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.volumeStep > 0;
        message = "The volume step must be greater than 0.";
      }
    ];

    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };

    home.packages = with pkgs; [
      alacritty
      swaynotificationcenter
      sway-contrib.grimshot
    ];

    home.file.".config/swaylock/config" = {
      text = ''
        image=${rootPath + "/wallpapers/300SL.png"}
      '';
    };

    midugh.rofi.enable = true;
    midugh.waybar = {
      enable = true;
      configFile = ../waybar/config/config.json;
      style = ../waybar/config/style.css;
    };

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

        output."*" = attrsets.filterAttrs (n: v: v != null) {
          background = strings.optionalString (cfg.wallpaper != null) "${cfg.wallpaper} fill";
        };

        input."*" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
          xkb_options = "caps:swapescape";
        };

        keybindings = mkOptionDefault {
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +${toString cfg.volumeStep}% && $refresh_i3status";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -${toString cfg.volumeStep}% && $refresh_i3status";
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
          "${modifier}+Shift+r" = "reload";
          "Print" = "exec ${lib.getExe pkgs.sway-contrib.grimshot}";
        };
        bars = [ ];

        startup = [{
          command =
            let
              script = pkgs.writeShellScriptBin "waybar-reload" ''
                ps -x | grep -E 'waybar$' | sed -E 's/\s*([0-9]+).*/\1/g' | xargs kill
                exec ${lib.getExe pkgs.waybar}
              '';
            in
            ''
              ${lib.getExe script}
            '';
          always = true;
        }
          {
            command = "${lib.getExe pkgs.swaynotificationcenter}";
            always = true;
          }
          (mkIf cfg.enableNetworkManager {
            command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
            always = true;
          })];
      };


      extraConfig = ''
        set $opacity 0.9
        for_window [app_id="Alacritty"] opacity $opacity

        default_border none
        for_window [class="^.*"] border pixel 2
      '';

    };
  };
}
