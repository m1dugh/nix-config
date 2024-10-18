{ pkgs
, ...
}:
{
    home.username = "midugh";
    home.homeDirectory = "/home/midugh";
    home.stateVersion = "24.05";

    home.packages = with pkgs; [
        kubectl
        helm
        sops
        yq-go
        jq
        awscli2
        gcc
        cargo
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

    programs.home-manager.enable = true;
}
