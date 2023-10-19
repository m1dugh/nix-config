{
  config,
  pkgs,
  lib,
  ...
}:
let
    dmenuCommand = "${pkgs.rofi}/bin/rofi -modi drun,run -show drun";
    lockscreen = ../wallpapers/archwave.png;
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

# desktop packages
        betterlockscreen
        i3-gaps
        imagemagick

# fonts
        font-awesome_6
        material-symbols
    ];

    imports = [
        (import ../modules/rofi {
            inherit terminal;
        })
        ../modules/nvim
        (import ../modules/zsh {
            withKubernetes = false;
        })
        ../modules/alacritty
        (import ../modules/i3 {
            i3pkg = pkgs.i3-gaps;
            inherit lockCommand dmenuCommand terminal statusCommand wallpaper;
        })
        ../modules/i3status-rust
        (import ../modules/git {
            extraConfig = {
                sendemail = {
                    smptencryption = "tls";
                    smtpserver = "smtp.office365.com";
                    smtpserverport = 587;
                    smtpuser = "firstname.lastname@epita.fr";
                };
            };
        })
    ];

    programs.home-manager.enable = true;

    programs.bash = {
        enable = true;
        bashrcExtra = ''
            export SHELL=zsh;
        '';
    };
}
