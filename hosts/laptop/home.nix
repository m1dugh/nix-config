{ pkgs
, stateVersion
, ...
}:
let
  wallpaper = ../../wallpapers/wallpaper.jpg;
  dmenuCommand = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
  lockCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  screenshotCommand = "${pkgs.flameshot}/bin/flameshot gui";
in
{
  midugh.nvim.enable = true;
  midugh.zsh = {
    enable = true;
    withKubernetes = true;
  };

  midugh.sway = {
      enable = true;
      enableNetworkManager = true;
  };

  midugh.git = {
    enable = true;
    editor = "nvim";
    username = "m1dugh";
    email = "romain.le-miere@epita.fr";
  };

  home = {
    inherit stateVersion;
    packages = with pkgs; [
      krb5
      sshfs

      poetry

      # LspServer
      rust-analyzer
      clang-tools

      discord
      # teams
      slack

      brave
      firefox

      imagemagick
    ];
  };

  services.ssh-agent.enable = true;
  programs.home-manager.enable = true;
}
