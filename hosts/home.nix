{
    config,
    lib,
    pkgs,
    home-manager,
    username,
    ...
}:

{
    home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "22.11";

        packages = with pkgs; [
            git-lfs
            playerctl
            gparted
            virt-manager

            discord
            teams

            brave
            firefox
            
            imagemagick
            feh
        ];
    };

    programs.git = {
        enable = true;
        userName = "m1dugh";
        userEmail = "romain.le-miere@epita.fr";
    };

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
            ];
            theme = "robbyrussel";
        };
    };
    programs.home-manager.enable = true;

    xfconf.settings = {
        xfce4-session = {
            "general/LockCommand" = "${pkgs.i3lock}/bin/i3lock";
        };
    };
}
