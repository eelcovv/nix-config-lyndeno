{
  config,
  pkgs,
  lib,
  ...
}: {
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "lsanche";
    homeDirectory = "/home/lsanche";
    enableNixpkgsReleaseCheck = true;

    packages = with pkgs; [
      # Fonts
      #neofetch
      #jq
      neofetch
    ];
  };

  programs = {
    bottom.enable = true;
    bat.enable = true;
    bat.config = {theme = "base16-256";};
    exa.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      plugins.src = (config.programs.nnn.package.src) + "/plugins";
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true; # seems this is a new addition
      history = {
        path = "$HOME/.cache/zsh/histfile";
      };
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        ls = "${pkgs.exa}/bin/exa --icons --group-directories-first -B";
      };
      initExtra = ''
        zmodload zsh/complist
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select

        # Vim bindings for tab menu
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history

        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT
        # TODO: Convert this to nix expressions
        alias d='dirs -v'
        for i ({1..9}) alias "$i"="cd +''${i}"; unset i

        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        typeset -A ZSH_HIGHLIGHT_PATTERNS
        ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
        bindkey '^ ' autosuggest-accept
        bindkey "$terminfo[kcuu1]" history-substring-search-up
        bindkey "$terminfo[kcud1]" history-substring-search-down
      '';
    };
    git = {
      enable = true;
      userName = "Lyndon Sanche";
      userEmail = "lsanche@lyndeno.ca";
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE90+2nMvJzOmkEGT3cyqHMESrrPQwVhe9/ToSlteJbB";
      signing.signByDefault = true;
      extraConfig = {
        pull.rebase = false;
        gpg.format = "ssh";
        "gpg \"ssh\"".program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
      };
      ignores = [
        "result"
        ".direnv/"
        ".envrc"
        ".vscode/"
      ];
    };
    ssh = let
      keys = (import ../info.nix).hostAuthorizedKeys;
    in {
      enable = true;

      matchBlocks =
        builtins.mapAttrs (name: value: {
          hostname = name;
          identityFile = "${(pkgs.writeText "lsanche-${name}.pub" ''
            ${value}
          '')}";
          identitiesOnly = true;
        })
        keys;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;

        format = lib.concatStrings [
          "$username$hostname$directory\n"
          "$battery"
          "$jobs"
          "$memory_usage"
          "$git_branch"
          "$git_status"
          "$rust"
          "$cmake"
          "$cmd_duration"
          "$nix_shell"
          "$character"
        ];

        cmd_duration = {
          min_time = 10000;
          format = "[$duration]($style) ";
          show_notifications = true;
          #cmd_duration.notification_timeout = 3000;
        };

        cmake = {
          format = "[$symbol]($version)]($style) ";
          style = "bold cyan";
        };

        hostname.format = "@[$hostname](bold yellow):";

        directory = {
          truncation_symbol = ".../";
          truncation_length = 5;
        };

        memory_usage = {
          disabled = true;
          threshold = 50;
        };

        git_branch.format = "[$symbol$branch]($style) ";

        jobs.symbol = " ";

        username = {
          format = "[$user]($style)";
          style_user = "bold green";
        };
      };
    };
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = false;
  };

  home.sessionVariables = {
    EDITOR = "vim";
    MANPAGER = "sh -c '${pkgs.util-linux}/bin/col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  #fonts.fontconfig.enable = true;

  # TODO: This module will be in next hm release
  #services.swayidle = {
  #  enable = true;
  #  events = [
  #    { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock"; }
  #  ];
  #  timeouts = [
  #    { timeout = 30; command = "if pgrep swaylock; then swaymsg 'output * dpms off'"; }
  #  ];
  #};

  #programs.firefox = {
  #  enable = true;
  #  package = pkgs.firefox-wayland;
  #};

  #services.gpg-agent = {
  #  enable = true;
  #  #enableSshSupport = true;
  #  pinentryFlavor = "gnome3";
  #};
  #services.gnome-keyring = {
  #  enable = true;
  #  components = [ "secrets" "ssh" ];
  #};

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  #home.stateVersion = "21.11";
}
