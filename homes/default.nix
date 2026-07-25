{
  inputs,
  pkgs,
  pkgs-local,
  pkgs-unstable,
  modules,
  stateVersion,
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
      inherit pkgs-local stateVersion;
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
      inherit pkgs-local stateVersion;
    };

    modules = [
      ./sncf.nix
    ]
    ++ modules;
  };
  "midugh-work" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit pkgs-unstable stateVersion;
    };
    modules = [
      ./work.nix
    ]
    ++ modules;
  };
}
