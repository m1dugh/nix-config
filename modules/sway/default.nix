{ config
, rootPath
, lib
, pkgs
, pkgs-local
, ...
}:
with lib;
let
  cfg = config.midugh.sway;
  terminalPkg = pkgs.alacritty;
  defaultConfig = config.wayland.windowManager.sway;
  rofi = getExe config.programs.rofi.finalPackage;
  menu = "${rofi} -show drun";
  emoji = "${rofi} -theme ${./config/emoji-theme.rasi} -show emoji -emoji-format '{emoji} {group}'";
  power-menu = "${rofi} -theme ${./config/power-menu-theme.rasi} -show power-menu -modi power-menu:'rofi-power-menu --no-text'";
  screenshotOptions = {
    options = {
      enable = mkEnableOption "screenshot package";
      package = mkOption {
        type = types.package;
        description = ''
          The package to use for the screen shot.
        '';
      };
      command = mkOption {
        type = types.str;
        description = ''
          The command to run to take a screenshot.
        '';
      };
    };
  };
in
{
  options.midugh.sway = {
    enable = mkEnableOption "sway config";
    wallpaper = mkOption {
      type = types.nullOr types.path;
      default = rootPath + "/wallpapers/wallpaper.jpg";
      description = "The path to the wall paper";
    };

    screenshot = mkOption {
      type = types.submodule screenshotOptions;
      default = rec {
        enable = true;
        package = pkgs-local.screenshot;
        command = lib.getExe package;
      };
    };

    swaylockPackage = mkOption {
      type = types.package;
      default = pkgs.swaylock-effects;
      example = literal "pkgs.swaylock-effects";
    };

    enableNetworkManager = mkEnableOption "network manager applet";

    volumeStep = mkOption {
      description = "The step the volume should be changed for the increase/decrease volume shortcut";
      type = types.int;
      default = 2;
    };
    brightnessStep = mkOption {
      description = "The step the brightness should be changed for the increase/decrease brightness shortcut";
      type = types.int;
      default = 10;
    };

    inactivityLockTime = mkOption {
      description = "The time after which the screen should be locked after inactivity. If null, swayidle will not lock screen";
      default = 1200;
      type = types.nullOr types.int;
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.volumeStep > 0;
        message = "The volume step must be greater than 0.";
      }
    ];

    midugh.rofi = {
      enable = true;
      wayland = true;
    };
    programs.rofi.terminal = getExe terminalPkg;

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };
    };

    home.packages = [
      terminalPkg
      pkgs.swaynotificationcenter
      pkgs.rofi-power-menu
      cfg.swaylockPackage
    ] ++ (lists.optional cfg.screenshot.enable cfg.screenshot.package);

    home.file.".config/swaylock/config" = {
      text = ''
        screenshots
        clock
        indicator-idle-visible
        indicator-radius=100
        indicator-thickness=7
        effect-blur=7x3
        effect-vignette=0.5:0.5
        ring-color=bb00cc
        key-hl-color=880033
        line-color=00000000
        inside-color=00000088
        separator-color=00000000
        fade-in=0.2
      '';
    };

    midugh.waybar = {
      enable = true;
      configFile = ../waybar/config/config.json;
      style = ../waybar/config/style.css;
    };

    wayland.windowManager.sway =
      let
        inherit (defaultConfig.config) left right up down;
      in
      {
        enable = true;
        config = rec {
          terminal = lib.getExe terminalPkg;
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
            "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ ${toString cfg.volumeStep}%+ --limit 1.0 && $refresh_i3status";
            "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_SINK@ ${toString cfg.volumeStep}%- && $refresh_i3status";
            "XF86MonBrightnessUp" = "exec --no-startup-id xbacklight -inc ${toString cfg.brightnessStep}";
            "XF86MonBrightnessDown" = "exec --no-startup-id xbacklight -dec ${toString cfg.brightnessStep}";
            "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
            "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
            "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
            "XF86AudioNext" = "exec --no-startup-id playerctl next";
            "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
            "${modifier}+Control+Shift+Right" = "move workspace to output right";
            "${modifier}+Control+Shift+Left" = "move workspace to output left";
            "${modifier}+Control+Shift+Up" = "move workspace to output up";
            "${modifier}+Control+Shift+Down" = "move workspace to output down";

            "${modifier}+Control+Shift+${right}" = "move workspace to output right";
            "${modifier}+Control+Shift+${left}" = "move workspace to output left";
            "${modifier}+Control+Shift+${up}" = "move workspace to output up";
            "${modifier}+Control+Shift+${down}" = "move workspace to output down";

            "${modifier}+d" = ''exec "${menu}"'';
            "${modifier}+r" = "mode resize";
            "${modifier}+Tab" = ''exec "${lib.getExe cfg.swaylockPackage}"'';
            "${modifier}+Shift+r" = "reload";
            "${modifier}+slash" = ''exec "${emoji}"'';
            "${modifier}+p" = ''exec "${power-menu}"'';
            "Print" = ''exec "${cfg.screenshot.command}"'';
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
            })
            (mkIf (cfg.inactivityLockTime != null) {
              command = ''
                exec swayidle -w \
                    timeout ${toString cfg.inactivityLockTime} 'swaylock -f' \
                    timeout ${toString (cfg.inactivityLockTime + 5)} 'swaymsg "output * power off"' \
                    resume 'swaymsg "output * power on"'
              '';
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
