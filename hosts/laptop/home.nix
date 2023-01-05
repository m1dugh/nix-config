{
    config,
    lib,
    pkgs,
    home-manager,
    username,
    ...
}:

let
    config-root = "../../configs";
    inherit username;
in {
    home = {
        packages = with pkgs; [
            krb5
            sshfs
        ];

        file = {
            ".zshrc".source = ../. + "${config-root}/zshrc";
            ".vimrc".source = ../. + "${config-root}/vimrc";
            "gdbinit".source = ../. + "${config-root}/gdbinit";
            ".config/i3/config".source = ../. + "${config-root}/i3-config";
            ".config/i3status/config".source = ../. + "${config-root}/i3status-config";
            ".config/alacritty/alacritty.yml".source = ../. + "${config-root}/alacritty.yml";
        };
    };
}
