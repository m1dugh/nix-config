{ config
, lib
, pkgs
, ...
}:
with lib;
let
    cfg = config.midugh.waybar;
in {
    options.midugh.waybar = {
        enable = mkEnableOption "waybar";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            waybar
        ];
    };
}
