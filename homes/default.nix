{
  inputs,
  pkgs,
  pkgs-local,
  pkgs-unstable,
  modules,
  ...
}:
let
  inherit (inputs) home-manager;
in
{
  home-manager.useGlobalPkgs = true;
  "midugh-pie" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      username = "romain.le-miere";
      inherit pkgs-local;
    };

    modules = [
      ./pie.nix
    ]
    ++ modules;
  };

  "midugh-sncf" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      username = "romain.le-miere";
      inherit pkgs-local;
    };

    modules = [
      ./sncf.nix
    ]
    ++ modules;
  };
  "midugh-work" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit pkgs-unstable;
    };
    modules = [
      ./work.nix
    ]
    ++ modules;
  };
}
