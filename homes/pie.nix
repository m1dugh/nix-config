{
  config,
  pkgs,
  lib,
  ...
}:
let
    dmenuCommand = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
    lockscreen = ../wallpapers/cisco.png;
    lockCommand = "i3lock -i ${lockscreen}";
    wallpaper = ../wallpapers/prologin-2023_wallpaper.png;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
in {

    fonts.fontconfig.enable = true;

    manual.manpages.enable = false;
    home.username = "romain.le-miere";
    home.homeDirectory = "/home/romain.le-miere";
    home.stateVersion = "23.05";

    home.keyboard = {
        layout = "us";
        variant = "altgr-intl";
        options = [
            "nodeadkeys"
        ];
    };

    home.packages = with pkgs; [
# rust
        cargo
        rust-analyzer

# go
        go

# fonts
        font-awesome_6
        material-symbols
    ];

    midugh.i3status-rust = {
        enable = true;
        network-devices = [
            "eth0"
        ];
    };

    midugh.rofi.enable = true;
    midugh.alacritty.enable = true;

    midugh.git = {
        enable = true;
        username = "romain.le-miere";
        email = "romain.le-miere@epita.fr";
#        extraConfig = {
#            sendemail = {
#                smptencryption = "tls";
#                smtpserver = "smtp.office365.com";
#                smtpserverport = 587;
#                smtpuser = "firstname.lastname@epita.fr";
#            };
#        };
    };

    midugh.i3 = {
        enable = true;
        inherit lockCommand dmenuCommand wallpaper terminal;
    };

    midugh.nvim = {
        enable = true;
        debuggers = {};
    };
    midugh.zsh = {
        enable = true;
        withKubernetes = true;
    };

    programs.home-manager.enable = true;

    programs.bash = {
        enable = true;
        bashrcExtra = ''
            exec zsh
        '';
    };
}
