{ config, ... }:

{
    time.timeZone = "Europe/Paris";
    imports = [
        ./services/config.nix
        ./users/config.nix
        ./packages/config.nix
        ./system/config.nix
        # ./specialisations/config.nix
    ];
}
