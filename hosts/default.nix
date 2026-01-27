{
  inputs,
  lib,
  system,
  username,
  pkgs-unstable,
  pkgs-local,
  pkgs-lanzaboote,
  modules,
  ...
}:
let
  inherit (inputs) home-manager;
  specialArgs = {
    inherit
      inputs
      username
      pkgs-local
      pkgs-unstable
      pkgs-lanzaboote
      system
      ;
    stateVersion = "25.11";
    rootPath = ../.;
  };
in
{
  midugh-laptop = lib.nixosSystem {
    inherit system specialArgs;
    modules = [
      ./laptop
      ./configuration.nix

      inputs.lanzaboote.nixosModules.lanzaboote

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
