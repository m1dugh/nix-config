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
    home-manager.useGlobalPkgs = true;
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
