{
  pkgs,
  stateVersion,
  config,
  pkgs-local,
  ...
}:
{
  midugh.nvim.enable = true;
  midugh.zsh = {
    enable = true;
    useLsd = true;
    extraScripts = [
      ''
        function awsctx() { 
            export AWS_PROFILE="$(aws configure list-profiles | fzf)" 
            echo "Switched to profile ""$AWS_PROFILE""." 
        }
      ''
    ];
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

  midugh.sway = {
    enable = true;
    enableNetworkManager = true;

    screenshot.package = pkgs-local.screenshot;
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
    packages = (
      with pkgs;
      [
        krb5
        sshfs

        keeweb

        poetry

        # LspServer
        rust-analyzer
        clang-tools

        discord
        # teams
        slack

        brave

        imagemagick

        whatsapp-for-linux

        kubelogin-oidc
        grim
      ]
    );
  };

  services.ssh-agent.enable = true;
  programs.home-manager.enable = true;
}
