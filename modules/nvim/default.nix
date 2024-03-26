{
    pkgs,
    config,
    lib,
    ...
}:
with lib;
let cfg = config.midugh.nvim;
in {
    options.midugh.nvim = {
        enable = mkEnableOption "nvim default config";
        useAliases = mkOption {
            description = "use `vi` and `vim` as aliases for `nvim`";
            type = types.bool;
            default = true;
        };
    };

    config = mkIf cfg.enable {
        home.file.".config/nvim" = {
            recursive = true;
            source = ./config;
        };

        home.packages = with pkgs; [
            ripgrep
        ];

        programs.neovim = {
            enable = true;
            viAlias = cfg.useAliases;
            vimAlias = cfg.useAliases;
            plugins = with pkgs; [
                vimPlugins.packer-nvim
                vimPlugins.nvim-dap
            ];
        };
    };
}
