{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , flake-utils
    , ...
    }:

    let
      system = "x86_64-linux";
      username = "midugh";
      overlay = final: prev:
        let
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
          };
        in
        {
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

      nixosModules = generateModules [ "xfce" ];

      homeManagerModules = generateModules [
        "alacritty"
        "git"
        "i3"
        "i3status-rust"
        "nvim"
        "rofi"
        "zsh"
        "sway"
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

      formatter = flake-utils.lib.eachDefaultSystemMap (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
