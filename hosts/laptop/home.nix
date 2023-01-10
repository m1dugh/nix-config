{
    pkgs,
    ...
}:
{
    home = {
        packages = with pkgs; [
            krb5
            sshfs
        ];
    };
}
