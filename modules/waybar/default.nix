{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.midugh.waybar;
  format = pkgs.formats.json { };
  mkConfig = path: ".config/waybar/${path}";
in
{
  options.midugh.waybar = {
    enable = mkEnableOption "waybar";
    config = mkOption {
      type = types.nullOr format.type;
      default = null;
      description = ''
        The config file for waybar.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The path to the config file.
      '';
    };

    style = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The file containing the style. If null, no style file will be added.
      '';
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = lib.xor (cfg.configFile == null) (cfg.config == null);
        message = ''
          One and only one of `midugh.waybar.configFile` and `midugh.waybar.config` must be set.
        '';
      }
    ];

    home.packages = with pkgs; [
      waybar
    ];

    home.file.${mkConfig "config"}.source =
      if cfg.config != null then pkgs.writeJSONText "config" cfg.config else cfg.configFile;

    home.file.${mkConfig "style.css"} = mkIf (cfg.style != null) {
      source = cfg.style;
    };
  };
}
