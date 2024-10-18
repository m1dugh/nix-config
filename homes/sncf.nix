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
    ];

    midugh.nvim = {
        enable = true;
        debuggers = { };
    };

    midugh.zsh = {
        enable = true;
        viMode = true;
    };

    program.home-manager.enable = true;
}
