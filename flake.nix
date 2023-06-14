{
  description = "Lyndon's NixOS setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "nixos-hardware/master";

    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cfetch = {
      url = "github:Lyndeno/cfetch/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironfetch = {
      url = "github:Lyndeno/ironfetch/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    site = {
      url = "github:Lyndeno/website-hugo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16-schemes = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };

    base16-vim-lightline = {
      url = "github:mike-hearn/base16-vim-lightline";
      flake = false;
    };

    wallpapers = {
      url = "github:Lyndeno/wallpapers";
      flake = false;
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    statix = {
      url = "github:nerdypepper/statix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = inputs @ {self, ...}: let
    inherit (inputs.nixpkgs) lib;
    lsLib = import ./lslib.nix {inherit lib;};

    commonModules = system: [
      inputs.home-manager.nixosModules.home-manager
      ./common.nix
      ./modules
      ./desktop
      ./users
      {
        environment.systemPackages = [
          inputs.cfetch.packages.${system}.default
          inputs.ironfetch.packages.${system}.default
        ];
        nixpkgs.config.allowUnfree = true;
      }
      inputs.stylix.nixosModules.stylix
      inputs.agenix.nixosModules.default
    ];

    mkSystem = folder: name: let
      hostInfo = import ./${folder}/${name}/info.nix;
    in
      lib.nixosSystem rec {
        inherit (hostInfo) system;
        modules =
          (import ./${folder}/${name} lib inputs (commonModules system))
          ++ [
            {networking.hostName = name;}
            {system.stateVersion = hostInfo.stateVersion;}
          ];
        specialArgs = {
          inherit inputs lsLib;
          hostName = name;
        };
      };
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;

        checks = {
          pre-commit-check = inputs.pre-commit-hooks-nix.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              statix.enable = true;
              deadnix.enable = true;
            };

            tools = {
              # Current version (0.5.6) incorrectly reports syntax errors in ./common/users.nix
              inherit (inputs.statix.packages.${system}) statix;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [inputs.agenix.packages.${system}.default statix deadnix];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      };
      flake = {
        nixosConfigurations = (folder:
          builtins.listToAttrs
          (
            map
            (x: {
              name = x;
              value = mkSystem folder x;
            })
            (lsLib.ls ./${folder})
          )) "hosts";
      };
    };
}
