{ pkgs
, ...
}:
{
  home.username = "midugh";
  home.homeDirectory = "/home/midugh";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    dig
    sops
    yq-go
    jq
    awscli2
    gcc
    cargo
    nodejs

    python312
    kubectx
    fzf
    stern

    # fonts
    fira-code
    nerd-fonts.fira-code
  ];

  midugh.git = {
    enable = true;
    username = "0301717D";
    email = "rlemiere@sncf.fr";
  };

  midugh.nvim = {
    enable = true;
    debuggers = { };
  };

  midugh.zsh = {
    enable = true;
    viMode = true;
  };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
}
