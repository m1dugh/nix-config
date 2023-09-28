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
    }: 
    
    let
        system = "x86_64-linux";
        username = "midugh";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        lib = nixpkgs.lib;
    in {

        packages.${system}.home-manager = home-manager.defaultPackage.${system};

        nixosConfigurations = (
            import ./hosts {
                inherit (nixpkgs) lib;
                inherit (self) inputs;
                inherit system pkgs username home-manager;
            }
        );

        homeConfigurations = (
            import ./homes {
                inherit (nixpkgs) lib;
                inherit (self) inputs;
                inherit system pkgs home-manager;
            }
        );
    };
}
