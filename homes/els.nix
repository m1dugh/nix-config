{
  pkgs,
  pkgs-unstable,
  lib,
  stateVersion,
  inputs,
  ...
}:
{
  home.username = "ext-rlemiere";
  home.homeDirectory = "/home/ext-rlemiere";
  home.stateVersion = stateVersion;

  home.packages =
    with pkgs;
    [
      ansible
      argocd
      awscli2
      azure-cli
      cargo
      dig
      fira-code
      fzf
      gcc
      grafanactl
      jq
      kubectl
      kubectx
      kubelogin
      kubelogin-oidc
      kubernetes-helm
      nerd-fonts.fira-code
      nodejs
      openssh
      postgresql_17
      python312
      python312Packages.debugpy
      sops
      stern
      unzip
      uv
      vault
      yq-go
    ]
    ++ (with pkgs-unstable; [
      terraform
      opentofu
      claude-code
      terraform-mcp-server
      rtk
    ]);

  midugh.nvim.enable = true;

  midugh.tmux.enable = true;

  programs.zsh.shellAliases = {
    poweroff = "powershell.exe -Command 'shutdown /s /t 0'";
  };

  midugh.zsh = {
    enable = true;
    viMode = true;
    useLsd = true;
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

        export http_proxy="http://localhost:3128" https_proxy="http://localhost:3128"
      ''
    ];
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  nix = {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
