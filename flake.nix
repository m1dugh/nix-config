{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    dragon-center = {
      url = "github:m1dugh/DragonCenterForLinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , dragon-center
    , home-manager
    , flake-utils
    , ...
    }:

    let
      system = "x86_64-linux";
      username = "midugh";
      mkDefaultArgs = system: 
      let
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        pkgs = import nixpkgs {
            config.allowUnfree = true;
            config.allowUnsupportedSystem = true;
            inherit system;
        };
      in {
        inherit (self) inputs;
        inherit
            pkgs-unstable
            pkgs
            system
            username
            ;
        inherit (nixpkgs) lib;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
      };
      pkgs = (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnsupportedSystem = true;
      });
      inherit (nixpkgs) lib;
      localLib = import ./lib {
        inherit lib pkgs;
      };
      generateModules = modules: lib.attrsets.genAttrs modules (name: import (./modules + "/${name}"));

      customPackages = pkgs
          // localLib.pkgs
          // self.packages.${system}
          // dragon-center.packages.${system}
          ;
      defaultArgs = {
        inherit (self) inputs;
        inherit
          system
          username
          home-manager
          pkgs-unstable;
        inherit lib;
        pkgs = customPackages;
      };
    in
    rec {
      # TODO: use flake-utils
      packages = flake-utils.lib.eachDefaultSystemMap(system:
      let
        defaultArgs = mkDefaultArgs system;
      in {
        home-manager = home-manager.defaultPackage.${system};
      } // (import ./pkgs defaultArgs));

      nixosModules = (generateModules [ "xfce" ]) // {
        dragon-center = dragon-center.nixosModules.default;
      };

      homeManagerModules = generateModules [
        "alacritty"
        "git"
        "i3"
        "i3status-rust"
        "nvim"
        "rofi"
        "zsh"
        "sway"
        "waybar"
      ];

      nixosConfigurations =
        let
          modules = {
            homeManager = lib.attrsets.attrValues homeManagerModules;
            nixos = lib.attrsets.attrValues nixosModules ++ [
              "${nixpkgs-unstable}/nixos/modules/services/display-managers/ly.nix"
            ];
          };
        in
        (
          import ./hosts (defaultArgs // {
            inherit modules;
          })
        );

      homeConfigurations = (
        import ./homes (defaultArgs // {
          modules = lib.attrsets.attrValues homeManagerModules;
        })
      );

      formatter = flake-utils.lib.eachDefaultSystemMap (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
