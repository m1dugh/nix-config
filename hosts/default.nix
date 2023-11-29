{
    inputs,
    lib,
    system,
    username,
    home-manager,
    pkgs,
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
                home-manager.extraSpecialArgs = { inherit username; };
                home-manager.users.${username} = {
                    imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];
                };
            }
        ];
    };
}
