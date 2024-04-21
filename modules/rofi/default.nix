{ config
, lib
, ...
}:
with lib;
let cfg = config.midugh.rofi;
in {
  options.midugh.rofi = {
    enable = mkEnableOption "rofi";

    terminal = mkOption {
      description = "The binary path to the terminal";
      default = null;
      type = types.nullOr types.str;
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/rofi/" = {
      source = ./config;
      recursive = true;
    };

    programs.rofi = {
      inherit (cfg) terminal;
      enable = true;
      extraConfig = {
        modi = "calc,drun,ssh";
      };
      theme = "themes/midugh-custom";
    };
  };
}
