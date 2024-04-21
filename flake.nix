{
    description = "My configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-unstable,
        home-manager,
        ...
    }: 
    
    let
        system = "x86_64-linux";
        username = "midugh";
        overlay = final: prev: 
        let pkgs-unstable = import nixpkgs-unstable {
            inherit system;
        };
        in {
            gdb_14 = pkgs-unstable.gdb;
        };
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.allowUnsupportedSystem = true;
            overlays = [
                overlay
            ];
        };
        inherit (nixpkgs) lib;
        generateModules = modules: lib.attrsets.genAttrs modules (name: import (./modules + "/${name}"));
    in 
    rec {
        packages.${system}.home-manager = home-manager.defaultPackage.${system};

        nixosModules = generateModules ["xfce"];

        homeManagerModules = generateModules [
            "alacritty"
            "git"
            "i3"
            "i3status-rust"
            "nvim"
            "rofi"
            "zsh"
        ];

        nixosConfigurations = 
        let modules = {
            homeManager = lib.attrsets.attrValues homeManagerModules;
            nixos = lib.attrsets.attrValues nixosModules;
        };
        in (
            import ./hosts {
                inherit (nixpkgs) lib;
                inherit (self) inputs;
                inherit system pkgs username home-manager modules;
            }
        );

        homeConfigurations = (
            import ./homes {
                inherit (nixpkgs) lib;
                inherit (self) inputs;
                inherit system pkgs home-manager;
                modules = lib.attrsets.attrValues homeManagerModules;
            }
        );
    };
}
