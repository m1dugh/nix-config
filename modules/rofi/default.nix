{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.midugh.rofi;
in
{
  options.midugh.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
        enable = true;
        extraConfig = {
          modi = "drun,emoji";
        };
        font = "monospace";
        theme = ./config/rofi-theme.rasi;
        plugins = [
            pkgs.rofi-emoji
          ];
      };
  };
}
