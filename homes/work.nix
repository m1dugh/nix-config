{
  pkgs,
  ...
}:
{
  home.username = "rlemiere";
  home.homeDirectory = "/home/rlemiere";
  home.stateVersion = "25.11";

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
  midugh.nvim = {
    enable = true;
    debuggers = { };
  };

  midugh.zsh = {
    enable = true;
    viMode = true;
  };

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
