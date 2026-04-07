{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  home.username = "rlemiere";
  home.homeDirectory = "/home/rlemiere";
  home.stateVersion = "25.11";

  home.packages =
    with pkgs;
    [
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

      scaleway-cli

      # fonts
      fira-code
      nerd-fonts.fira-code
    ]
    ++ (with pkgs-unstable; [
      terraform
      opentofu
    ]);

  midugh.nvim.enable = true;

  midugh.tmux.enable = true;

  midugh.zsh = {
    enable = true;
    viMode = true;
    useLsd = true;
    completions.scw = {
      command = ''
        source <(${pkgs.scaleway-cli}/bin/scw autocomplete script)
      '';
      enable = false;
    };
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
