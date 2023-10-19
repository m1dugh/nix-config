{
    ...
}:
{
    home.file.".config/alacritty" = {
        recursive = true;
        source = ./config;
    };
    programs.alacritty = {
        enable = true;
    };
}
