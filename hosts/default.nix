{ inputs
, lib
, system
, username
, home-manager
, pkgs
, modules
, ...
}:

let stateVersion = "24.05";
in {
  midugh-laptop = lib.nixosSystem {
    inherit system;
    specialArgs = { 
        inherit username inputs pkgs stateVersion; 
    };
    modules = [
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit username stateVersion;
        };
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
