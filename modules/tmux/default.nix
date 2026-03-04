{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.midugh.tmux;
in
{
  options.midugh.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
    };
  };
}
