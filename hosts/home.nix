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
            imagemagick
            firefox
            brave
            discord
            playerctl
            gparted
            virt-manager
            teams
        ];
    };
}
