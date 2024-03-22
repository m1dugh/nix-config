{
    description = "My configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
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
            config.allowUnsupportedSystem = true;
        };
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
