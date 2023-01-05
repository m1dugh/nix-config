{
    description = "My configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        ...
    } @ inputs: 
    
    let
        system = "x86_64-linux";
        username = "midugh";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = (
            import ./hosts {
                inherit (nixpkgs) lib;
                inherit (self) inputs;
                inherit system pkgs username home-manager;
            }
            # midugh = lib.nixosSystem {
            #    inherit pkgs;
            #    inherit (nixpkgs) lib;
            #    inherit system;
            #    modules = [
            #        ./configuration.nix
            #        home-manager.nixosModules.home-manager {
            #            home-manager.useGlobalPkgs = true;
            #            home-manager.useUserPackages = true;
            #            home-manager.users.${username} = {
            #                imports = [ ./users/midugh.nix ];
            #            };
            #        }
            #    ];
            # };
        );
    };
}
