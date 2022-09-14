{
  description = "Lyndon's NixOS setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "nixos-hardware/master";
    cfetch = {
      url = github:Lyndeno/cfetch/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    site = {
      url = github:Lyndeno/website-hugo;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16-schemes = {
      url = github:base16-project/base16-schemes;
      flake = false;
    };

    base16-vim-lightline = {
      url = github:mike-hearn/base16-vim-lightline;
      flake = false;
    };

    base16-waybar = {
      url = github:mnussbaum/base16-waybar;
      flake = false;
    };

    wallpapers = {
      url = github:Lyndeno/wallpapers;
      flake = false;
    };

    agenix = {
      url = github:ryantm/agenix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = github:danth/stylix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = inputs@{ self, ... }:
  let
    makePkgs = system: import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    lib = inputs.nixpkgs.lib;

    commonModules = let
      base16Scheme = "${inputs.base16-schemes}/gruvbox-dark-hard.yaml";
    in system: [
      inputs.home-manager.nixosModules.home-manager
      ./common
      ./users
      ./modules
      ./programs
      ({config, ...}: {
        environment.systemPackages = [ inputs.cfetch.packages.${system}.default ];
      })
      inputs.stylix.nixosModules.stylix
      ({config, pkgs, ...}: {
        #nixpkgs.overlays = [ (self: super: {
        #  myTheme = self.writeText "myTheme.yaml" builtins.readFile base16Scheme;
        #}) ];
        stylix.image = "${inputs.wallpapers}/starry.jpg";
        #lib.stylix.colors = config.lib.base16.mkSchemeAttrs base16Scheme;
        stylix.base16Scheme = let
          myTheme = pkgs.writeTextFile { name = "myTheme.yaml"; text = builtins.replaceStrings [ "Gruvbox dark, hard" ] [ "Gruvbox" ] (builtins.readFile base16Scheme); destination = "/myTheme.yaml"; };
        in "${myTheme}/myTheme.yaml";
        stylix.fonts = let
          cascadia = (pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; });
        in {
          serif = {
            package = cascadia;
            name = "CaskaydiaCove Nerd Font";
          };
          sansSerif = {
            package = cascadia;
            name = "CaskaydiaCove Nerd Font";
          };
          monospace = {
            package = cascadia;
            name = "CaskaydiaCove Nerd Font Mono";
          };
        };

      })
      inputs.agenix.nixosModule
    ];

    mkSystem = name: let
      hostInfo = import ./hosts/${name}/info.nix;
    in lib.nixosSystem rec {
      system = hostInfo.system;
      pkgs = makePkgs system;
      modules = (commonModules system) ++ (import ./hosts/${name} inputs);
      specialArgs = { inherit inputs; };
    };

  in {
    nixosConfigurations = builtins.listToAttrs
    (map
      (x: {
        name = x;
        value = mkSystem x;
      })
      (builtins.attrNames (builtins.readDir ./hosts))
    );
  };
}
