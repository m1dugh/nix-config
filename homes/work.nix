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

      claude-code
      claude-code-router
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
        aws_profile_file="''${HOME}/.aws/awsctx"

        if [ -f "$aws_profile_file" ]; then
            export AWS_PROFILE="$(cat "$aws_profile_file")"
        fi

        awsctx() { 
            profiles="$(${lib.getExe pkgs.awscli2} configure list-profiles)"
            if [ -n "$AWS_PROFILE" ] && echo "$profiles" | grep -q "$AWS_PROFILE"; then
                profiles=$(echo "$profiles" | sed "s/$AWS_PROFILE/$(echo -ne "\033[0;32m$AWS_PROFILE\033[0m")/g")
            fi
            result="$(echo "$profiles" | ${lib.getExe pkgs.fzf} --ansi)"
            if [ -n "$result" ]; then
                export AWS_PROFILE="$result"
                echo "$result" > $aws_profile_file
                echo "Switched to profile $AWS_PROFILE."
            fi
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
