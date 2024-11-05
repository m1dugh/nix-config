{ inputs
, lib
, system
, username
, pkgs
, pkgs-unstable
, pkgs-local
, dragon-center-pkgs
, modules
, ...
}:
let
  inherit (inputs) home-manager;
  specialArgs = {
    inherit
        inputs
        username
        pkgs-local
        dragon-center-pkgs
        pkgs-unstable
        pkgs
        system
        ;
    stateVersion = "24.05";
    rootPath = ../.;
  };
in
{
  midugh-laptop = lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.${username} = {
          imports = [
            ./home.nix
            ./laptop/home.nix
          ] ++ modules.homeManager;
        };
      }
    ] ++ modules.nixos;
  };
}
