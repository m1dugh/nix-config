{ pkgs
, config
, lib
, ...
}:
with lib;
let inherit (import ./lib.nix {
  inherit lib;
}) debuggerType;
  cfg = config.midugh.nvim;
in
{
  options.midugh.nvim = {
    enable = mkEnableOption "nvim default config";
    useAliases = mkOption {
      description = "use `vi` and `vim` as aliases for `nvim`";
      type = types.bool;
      default = true;
    };

    debuggers = mkOption {
      description = "Configurations for debuggers";
      type = types.attrsOf debuggerType;
      example = {
        gdb = {
          enable = true;
          package = pkgs.gdb_14;
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.file.".config/nvim" = {
      recursive = true;
      source = ./config;
    };

    home.packages =
      let
        debuggerPackages =
          let
            debuggers = lib.attrValues cfg.debuggers;
            filtered = builtins.filter (dbg: dbg.enable) debuggers;
          in
          builtins.map (dbg: dbg.package) filtered;
      in
      (with pkgs; [
        ripgrep
        tree-sitter
      ] ++ debuggerPackages);

    programs.neovim = {
      enable = true;
      viAlias = cfg.useAliases;
      vimAlias = cfg.useAliases;
      package = pkgs.neovim-unwrapped;
      plugins = with pkgs; [
        vimPlugins.lazy-nvim
        vimPlugins.nvim-dap
      ];
    };
  };
}
