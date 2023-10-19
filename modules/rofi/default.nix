{
    terminal,
}:
{
    ...
}:
{
    home.file.".config/rofi/" = {
        source = ./config;
        recursive = true;
    };

    programs.rofi = {
        inherit terminal;
        enable = true;
        extraConfig = {
            modi = "calc,drun,ssh";
        };
        theme = "themes/midugh-custom";
    };
}
