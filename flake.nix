{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";

    lexical = {
      type = "github";
      owner = "lexical-lsp";
      repo = "lexical";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    lanzaboote,
    ...
  } @ inputs: let
    overlays = [
      (final: prev: {
        lutris = prev.lutris.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "lutris";
            repo = "lutris";
            rev = "06cd70cc7e440d5f98003abc8dc614c8f029e0d3";
            hash = "sha256-Nc051PnCH2LFrBzRLYmDOTH5E6LpMTxJJQdk6wnxF0s=";
          };
        });
        obsidian-wayland = prev.obsidian.override {electron = final.electron_24; };
      })
    ];
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          lanzaboote.nixosModules.lanzaboote
          {
            nixpkgs = {
              inherit overlays;
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "electron-25.9.0"
                  "electron-24.8.6"
                ];
              };
            };
          }
          hyprland.nixosModules.default
          ./system/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jacob = import ./home/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
    };
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      pets-nvim = pkgs.callPackage ./pkgs/pets-nvim.nix {};
      nest-nvim = pkgs.callPackage ./pkgs/nest-nvim.nix {};
      icon-picker-nvim = pkgs.callPackage ./pkgs/icon-picker.nix {};
      transparent-nvim = pkgs.callPackage ./pkgs/transparent-nvim.nix {};
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
