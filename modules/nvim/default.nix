{
    pkgs,
    ...
}:
{
    home.file.".config/nvim" = {
        recursive = true;
        source = ./config;
    };

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        plugins = [
            pkgs.vimPlugins.packer-nvim
        ];
    };
}
