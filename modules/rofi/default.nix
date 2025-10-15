{
  config,
  options,
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
    wayland = mkEnableOption "wayland mode for rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi =
      let
        package = if cfg.wayland then pkgs.rofi-wayland else options.programs.rofi.package.default;
        waylandOverride =
          pkg:
          if (cfg.wayland && builtins.hasAttr "override" pkg) then
            (pkg.override {
              rofi-unwrapped = package;
            })
          else
            pkg;
      in
      {
        enable = true;
        inherit package;
        extraConfig = {
          modi = "drun,emoji";
        };
        font = "monospace";
        theme = ./config/rofi-theme.rasi;
        plugins = (
          builtins.map waylandOverride [
            pkgs.rofi-emoji
          ]
        );
      };
  };
}
