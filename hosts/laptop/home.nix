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
  midugh.i3 = {
    enable = true;
    inherit lockCommand dmenuCommand wallpaper terminal screenshotCommand;
  };

  midugh.i3status-rust = {
    enable = true;
    show-battery = true;
    network-devices = [
      "enp60s0"
      "wlp61s0"
    ];
  };

  midugh.rofi.enable = true;
  midugh.alacritty.enable = true;

  midugh.nvim.enable = true;
  midugh.zsh = {
    enable = true;
    withKubernetes = true;
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

  xfconf.settings = {
    xfce4-session = {
      "general/LockCommand" = "${lockCommand}";
    };
    xfce4-keyboard-shortcuts = {
      "commands/custom/Print" = screenshotCommand;
    };
  };

  services.ssh-agent.enable = true;
  programs.home-manager.enable = true;
}
