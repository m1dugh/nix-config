{
    inputs,
    lib,
    system,
    username,
    home-manager,
    pkgs,
    modules,
    ...
}:

{
    midugh-laptop = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username inputs pkgs; };
        modules = [
            ./laptop
            ./configuration.nix

            home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                    inherit username;
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
