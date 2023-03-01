{
    pkgs,
    home-manager,
    ...
}:
{
    home = {
        stateVersion = "22.11";
        packages = with pkgs; [
            krb5
            sshfs

            poetry
        ];
    };

    xsession.windowManager.i3.config = {

        workspaceOutputAssign = [
        {
            workspace = "1";
            output = "eDP-1-1";
        }
        {
            workspace = "2";
            output = "HDMI-0";
        }
        ];
    };
}
