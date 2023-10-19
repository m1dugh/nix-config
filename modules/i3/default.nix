{
    i3pkg ? null,
    modifier ? "Mod4",
    lockCommand,
    dmenuCommand,
    terminal,
    statusCommand,
    wallpaper,
    swapEscape ? true,
}:
{
    config,
    lib,
    pkgs,
    ...
}:
{
    home.packages = with pkgs; [
        flameshot
        picom
    ];

    xsession.windowManager.i3 = {
        enable = true;
        package = if i3pkg == null then pkgs.i3-gaps else i3pkg;
        config = {
            terminal = terminal;
            modifier = modifier;
            gaps = {
                outer = 5;
                inner = 10;
            };

            fonts = {
                names = ["DejaVu Sans Mono"];
                style = "Bold Semi-Condensed";
                size = 11.0;
            };

            keybindings = lib.mkOptionDefault {
                "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status";
                "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status";
                "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
                "XF86AudioMicMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
                "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
                "XF86AudioNext" = "exec --no-startup-id playerctl next";
                "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
                "${modifier}+Control+Shift+Right" = "move workspace to output right";
                "${modifier}+Control+Shift+Left" = "move workspace to output left";
                "${modifier}+Control+Shift+Up" = "move workspace to output up";
                "${modifier}+Control+Shift+Down" = "move workspace to output down";

                "${modifier}+l" = "exec ${lockCommand}";
                "${modifier}+d" = ''exec "${dmenuCommand}"'';
                "${modifier}+r" = "mode resize";
                "${modifier}+BackSpace" = ''exec "pkill -u $USER"'';
                "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
            };

            bars = [{
               inherit statusCommand;
               position = "top";
               trayOutput = "primary";

               fonts = {
                   names = ["FiraSans" "Pango"];
                   style = "Bold Semi-Condensed";
                   size = 14.0;
               };
            }];

            startup = [
            {
                command = "${pkgs.feh}/bin/feh --bg-scale ${wallpaper}";
                always = true;
                notification = true;
            }
            {
                command = "exec ${pkgs.picom}/bin/picom";
                always = true;
            }
            (if swapEscape then {
                command = ''${pkgs.xorg.setxkbmap}/bin/setxkbmap -option "caps:swapescape"'';
                always = true;
            } else {})
            ];
        };
        extraConfig = ''
            for_window [class="^.*"] border pixel 2
            '';
    };

    services.screen-locker = {
        enable = true;
        lockCmd = lockCommand;
    };
}
