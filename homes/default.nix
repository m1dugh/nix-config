{
    lib,
    inputs,
    system,
    home-manager,
    pkgs,
    ...
}:
let username = "romain.le-miere";
in {
    "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
            inherit username;
        };
        modules = [
            ./pie.nix
        ];
    };
}
