{ inputs
, lib
, system
, username
, home-manager
, pkgs
, pkgs-unstable
, modules
, ...
}:
let
  defaultSpecialArgs = {
    inherit username;
    stateVersion = "24.05";
    rootPath = ../.;
  };
in
{
  midugh-laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs pkgs-unstable;
    } // defaultSpecialArgs;
    modules = [
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = defaultSpecialArgs;
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
