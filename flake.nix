{
    description = "My configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = {
        self,
        nixpkgs,
        ...
    } @ inputs: 
    
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        lib = nixpkgs.lib;
    in {
        nixosConfigurations = {
            midugh-nixos = lib.nixosSystem {
                inherit system;
                modules = [
                    ./config.nix
                ];
            };
        };
    };
}
