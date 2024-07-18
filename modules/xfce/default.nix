{ pkgs
, config
, lib
, ...
}:
with lib;
let cfg = config.midugh.xfce;
in {
  options.midugh.xfce = {
    enable = mkEnableOption "XFCE config";

    defaultSession = mkOption {
      type = types.str;
      description = "The session to open for the desktop manager";
      example = "none+i3";
      default = "xfce+i3";
    };

    commands = mkOption {
      description = "The commands for the xfce session";
      type = types.submodule ({
        options = {
          lock = mkOption {
            type = types.nullOr types.str;
            description = "The command to run on lock";
          };

          screenshot = mkOption {
            type = types.nullOr types.str;
            description = "The command to run on screenshot";
          };
        };
      });

      default = {
        lock = null;
        screenshot = null;
      };
    };

    keyboard = mkOption {
      description = "The keyboard config";
      default = {
        layout = "us";
        variant = "altgr-intl";
        options = "nodeadkeys,caps:swapescape";
      };

      type = types.submodule ({
        options = {
          layout = mkOption {
            type = types.str;
            description = "The keyboard layout.";
          };
          variant = mkOption {
            type = types.str;
            description = "The keyboard variant to use";
          };

          options = mkOption {
            type = types.str;
            description = "The keyboard options to use";
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      betterlockscreen
    ];

    services.displayManager = {
        inherit (cfg) defaultSession;
    };


    services.xserver = {
      xkb = {
        inherit (cfg.keyboard) layout variant options;
      };

      enable = true;

      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
          enableScreensaver = false;
        };
      };

      windowManager.i3 = {
        enable = true;
      };
    };
  };
}
