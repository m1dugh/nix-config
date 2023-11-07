{
    netDevice ? null,
    battery ? false,
}:
{
    lib,
    ...
}:
{
    programs.i3status-rust = {
        enable = true;
        bars.default = {
            blocks = [
            (lib.mkIf (netDevice != null) {
                block = "net";
                device = netDevice;
                format = " $ip ";
            })
            (lib.mkIf battery {
                block = "battery";
                format = " $icon $percentage $time ";
            })
            {
                block = "cpu";
                interval = 1;
            }
            {
                block = "memory";
                interval = 1;
                format = " $icon $mem_used.eng(prefix:Mi)/$mem_total.eng(prefix:Mi)($mem_used_percents.eng(w:2)) ";
            }
            {
                block = "disk_space";
                path = "/";
                info_type = "available";
            }
            {
                block = "load";
                interval = 1;
                format = " $icon $1m ";
            }
            {
                block = "sound";
                click = [{
                    button = "left";
                    cmd = "pavucontrol";
                }];
            }
            {
                block = "custom";
                interval = 1;
                command = ''date "+%a %d/%m %H:%M:%S"'';
            }
            ];

            settings = {
                theme = {
                    theme = "solarized-dark";
                };
            };
            icons = "awesome6";
            theme = "gruvbox-dark";
        };
    };
}
