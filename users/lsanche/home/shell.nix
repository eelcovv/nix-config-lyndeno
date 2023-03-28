{
  pkgs,
  lib,
  ...
}: {
  programs = {
    bat.enable = true;
    bat.config = {theme = "base16-256";};
    exa = {
      enable = true;
      enableAliases = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
        "-B"
      ];
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
}
