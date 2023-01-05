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
            krb5
            sshfs
        ];
    };
}
