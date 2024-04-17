{
    home-manager,
    pkgs,
    modules,
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
        ] ++ modules;
    };
}
