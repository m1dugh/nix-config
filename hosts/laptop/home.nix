{ pkgs
, stateVersion
, ...
}:
{
  midugh.nvim.enable = true;
  midugh.zsh.enable = true;

  midugh.sway = {
    enable = true;
    enableNetworkManager = true;
  };

  wayland.windowManager.sway.config.input."1739:52653:CUST0001:00_06CB:CDAD_Touchpad" = {
    tap = "enabled";
    dwt = "enabled";
    middle_emulation = "enabled";
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

      whatsapp-for-linux

      kubelogin
    ];
  };

  services.ssh-agent.enable = true;
  programs.home-manager.enable = true;
}
