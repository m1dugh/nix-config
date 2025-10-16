{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    burpsuitepro = {
      url = "github:xiv3r/Burpsuite-Professional";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      dragon-center,
      home-manager,
      flake-utils,
      treefmt-nix,
      ...
    }:

    let
      formatter-config =
        { pkgs, ... }:
        {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.stylua.enable = true;
          programs.prettier.enable = true;
        };
      treefmt-eval = flake-utils.lib.eachDefaultSystemMap (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        treefmt-nix.lib.evalModule pkgs formatter-config
      );
      system = "x86_64-linux";
      username = "midugh";
      inherit (nixpkgs) lib;
      mkDefaultArgs =
        system:
        let
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          pkgs = import nixpkgs {
            config.allowUnfree = true;
            config.allowUnsupportedSystem = true;
            inherit system;
          };
          pkgs-local = self.packages.${system};
          dragon-center-pkgs = dragon-center.packages.${system};
        in
        {
          inherit (self) inputs;
          inherit
            pkgs-unstable
            pkgs-local
            pkgs
            system
            username
            lib
            dragon-center-pkgs
            ;
        };
      generateModules = modules: lib.attrsets.genAttrs modules (name: import (./modules + "/${name}"));

      defaultArgs = mkDefaultArgs system;
    in
    rec {
      packages = flake-utils.lib.eachDefaultSystemMap (
        system:
        let
          defaultArgs = mkDefaultArgs system;
        in
        {
          inherit (home-manager.packages.${system}) home-manager;
        }
        // (import ./pkgs defaultArgs)
      );

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
            nixos = lib.attrsets.attrValues nixosModules;
          };
        in
        (import ./hosts (
          defaultArgs
          // {
            inherit modules;
          }
        ));

      homeConfigurations = (
        import ./homes (
          defaultArgs
          // {
            modules = lib.attrsets.attrValues homeManagerModules;
          }
        )
      );

      formatter = flake-utils.lib.eachDefaultSystemMap (
        system: treefmt-eval.${system}.config.build.wrapper
      );
    };
}
