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
      python312Packages.debugpy
      kubectx
      fzf
      stern

      scaleway-cli
      argocd

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

    extraScripts = [
      ''
        awsctx() { 
            profiles="$(${lib.getExe pkgs.awscli2} configure list-profiles)"
            if [ -n "$AWS_PROFILE" ] && echo "$profiles" | grep -q "$AWS_PROFILE"; then
                profiles="$(echo "$profiles" | grep -v "$AWS_PROFILE")"
                profiles=$(echo "\033[0;32m$AWS_PROFILE\033[0m\n$profiles")
            fi
            export AWS_PROFILE="$(echo "$profiles" | ${lib.getExe pkgs.fzf} --ansi)" 
            echo "Switched to profile $AWS_PROFILE."
        }
      ''
    ];
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
