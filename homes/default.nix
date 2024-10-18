{ home-manager
, pkgs
, modules
, ...
}:
{
  home-manager.useGlobalPkgs = true;
  "midugh-pie" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      username = "romain.le-miere";
    };

    modules = [
      ./sncf.nix
    ] ++ modules;
  };

  "midugh-sncf" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      username = "romain.le-miere";
    };

    modules = [
      ./sncf.nix
    ] ++ modules;
  };
}
