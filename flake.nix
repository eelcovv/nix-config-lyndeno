{
  description = "Lyndon's NixOS setup";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
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

    base16 = {
      url = github:SenchoPens/base16.nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    base16-alacritty = {
      url = github:aarowill/base16-alacritty;
      flake = false;
    };

    base16-gruvbox-scheme = {
      url = github:dawikur/base16-gruvbox-scheme;
      flake = false;
    };

    base16-sway = {
      url = github:rkubosz/base16-sway;
      flake = false;
    };
    base16-vim = {
      url = github:chriskempson/base16-vim;
      flake = false;
    };
    base16-vim-lightline = {
      url = github:mike-hearn/base16-vim-lightline;
      flake = false;
    };
  };
  
  outputs = { self, nixpkgs, home-manager, nixos-hardware, cfetch, site, base16, base16-gruvbox-scheme, base16-alacritty, base16-sway, base16-vim, base16-vim-lightline, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    lib = nixpkgs.lib;

    commonModules = [
      home-manager.nixosModules.home-manager
      ./common.nix
      ./users
      ./modules
      ({config, ...}: {
        environment.systemPackages = [ cfetch.packages.${system}.default ];
      })
      base16.nixosModule {
        scheme = "${base16-gruvbox-scheme}/gruvbox-dark-hard.yaml";
      }
      ({config, ...}: {
       # home-manager.users.lsanche.programs.alacritty.settings.colors = 
       # with config.scheme.withHashtag; let default = {
       #   black = base00; white = base07;
       #   inherit red green yellow blue cyan magenta;
       # };
       # in {
       #   primary = { background = "#000000"; foreground = base07; };
       #   cursor = { text = base02; cursor = base07; };
       #   normal = default; bright = default; dim = default;
       # };
       home-manager.users.lsanche = {
         programs.alacritty.settings = {
           import = [
             (config.scheme { templateRepo = base16-alacritty; target = "default-256"; })
           ];
         };
         programs.vim.extraConfig =
           builtins.readFile ( config.scheme { templateRepo = base16-vim; target = "default"; }) + builtins.readFile ( config.scheme {
           templateRepo = base16-vim-lightline; target = "default"; });
         #wayland.windowManager.sway.extraConfig =
         #  builtins.readFile (config.scheme { templateRepo = base16-sway; target = "colors"; });
         wayland.windowManager.sway.config.colors = with config.scheme.withHashtag; {
           background = base07;
           focused = {
             border = base05;
             background = base0D;
             text = base00;
             indicator = base0D;
             childBorder = base0D;
           };
           focusedInactive = {
             border = base01;
             background = base01;
             text = base05;
             indicator = base03;
             childBorder = base01;
           };
           unfocused = {
             border = base01;
             background = base00;
             text = base05;
             indicator = base01;
             childBorder = base01;
           };
           urgent = {
             border = base08;
             background = base08;
             text = base00;
             indicator = base08;
             childBorder = base08;
           };
           placeholder = {
             border = base00;
             background = base00;
             text = base05;
             indicator = base00;
             childBorder = base00;
           };
         };
       };
      })
    ];

    mkSystem = extraModules: lib.nixosSystem {
      inherit system pkgs;
      modules = commonModules ++ extraModules;
    };

  in {
    nixosConfigurations = {
      neo = with nixos-hardware.nixosModules; mkSystem [
        ./hosts/neo
        dell-xps-15-9560-intel
        common-cpu-intel-kaby-lake
      ];

      morpheus = mkSystem [ ./hosts/morpheus ];

      oracle = mkSystem [
        ./hosts/oracle
        ({config, ...}: {
          networking.firewall.allowedTCPPorts = [
            80
            443
          ];
          services.nginx.enable = true;
          services.nginx.virtualHosts."cloud.lyndeno.ca" = {
            root = "${site.packages.${system}.default}/";
          };
        })
      ];

      vm = mkSystem [ ./hosts/vm ];
    };
  };
}
