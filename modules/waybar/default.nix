{ config
, lib
, pkgs
, ...
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
      type = format.type;
      default = { };
      description = ''
        The config file for waybar.
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
    home.packages = with pkgs; [
      waybar
    ];

    home.file.${mkConfig "config"}.source = pkgs.writeJSONText "config" cfg.config;

    home.file.${mkConfig "style.css"} = mkIf (cfg.style != null) {
      text = cfg.style;
    };
  };
}
