{
    lib,
    config,
    ...
}:
with lib;
let cfg = config.midugh.alacritty;
in {
    options.midugh.alacritty = {
        enable = mkEnableOption "alacritty";
    };

    config = mkIf cfg.enable {

        home.file.".config/alacritty" = {
            recursive = true;
            source = ./config;
        };

        programs.alacritty = {
            enable = true;
        };
    };
}
