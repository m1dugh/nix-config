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

        packages = with pkgs; [
            git-lfs
            playerctl
            gparted
            virt-manager
        ];

        stateVersion = "23.11";
    };

}
