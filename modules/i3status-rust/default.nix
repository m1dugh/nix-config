{ config
, lib
, ...
}:
with lib;
let cfg = config.midugh.i3status-rust;
in {
  options.midugh.i3status-rust = {
    enable = mkEnableOption "i3status rust";

    network-devices = mkOption {
      type = types.listOf types.str;
      description = "The list of network devices to display.";
      default = [ ];
      example = [ "wlan0" ];
    };

    show-battery = mkEnableOption "show the battery level";
  };

  config.programs.i3status-rust = lib.mkIf cfg.enable {
    enable = true;
    bars.default = {
      blocks =
        (builtins.map
          (device: {
            block = "net";
            inherit device;
            format = " $ip ";
            format_alt = " ${device}: $ip ";
          })
          cfg.network-devices)
        ++ [
          (lib.mkIf cfg.show-battery {
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
