{ lib
, config
, ...
}:
with lib;
let cfg = config.midugh.zsh;
in {
  options.midugh.zsh = {
    enable = mkEnableOption "zsh default config";

    historySize = mkOption {
      type = types.int;
      default = 100000;
      description = "The size of the history";
    };

    theme = mkOption {
      type = types.str;
      default = "robbyrussell";
      description = "The OhMyZsh theme";
    };

    withKubernetes = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to add kubernetes auto complete";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = cfg.theme;
      };

      history = {
        size = cfg.historySize;
        save = cfg.historySize;
      };

      initExtra = (strings.optionalString cfg.withKubernetes ''
        if (( $+commands[kubectl] )); then
            # If the completion file doesn't exist yet, we need to autoload it and
            # bind it to `kubectl`. Otherwise, compinit will have already done that.
            if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubectl" ]]; then
              typeset -g -A _comps
              autoload -Uz _kubectl
              _comps[kubectl]=_kubectl
            fi

            kubectl completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_kubectl" &|
        fi

        # autoload -Uz vcs_info
        # precmd() { vcs_info }
        # zstyle ':vcs_info:git:*' formats '%b '
        # setopt PROMPT_SUBST
        # PROMPT='%(?:%{%}➜ :%{%}➜ ) %{%}%c%{%} $(git_prompt_info)'
      '');
      shellAliases = (mkIf cfg.withKubernetes {
        k = "kubectl";
      });
    };
  };
}
