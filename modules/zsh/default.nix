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

    viMode = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable vim mode";
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
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = cfg.historySize;
        save = cfg.historySize;
      };

      initExtra = strings.concatStringsSep "\n" [
      ''
      ZSH_CACHE_DIR=''${ZSH_CACHE_DIR:-~/.config/zsh/}
      ''
      (strings.optionalString cfg.withKubernetes ''
        source <(kubectl completion zsh)
      '')

      ''
      zmodload zsh/complist
      bindkey '^E' autosuggest-accept
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      fpath=(${./prompt} $fpath)
      autoload -Uz prompt_custom_setup && prompt_custom_setup
      ''

      (strings.optionalString cfg.viMode ''
       bindkey -v
       export KEYTIMEOUT=1
       bindkey -M menuselect 'h' vi-backward-char
       bindkey -M menuselect 'k' vi-up-line-or-history
       bindkey -M menuselect 'l' vi-forward-char
       bindkey -M menuselect 'j' vi-down-line-or-history
      '')

      ];
      shellAliases = lib.mkMerge 
      [
          (mkIf cfg.withKubernetes { k = "kubectl"; })
          {
            ls = "ls --color=auto";
            ga = "git add";
            gp = "git push";
            gcmsg = "git commit -m";
            gcam = "git commit -am";
            gl = "git pull";
            gpr = "git pull --rebase";
            gst = "git status";
            gd = "git diff";
            gco = "git checkout";
            gsw = "git switch";
            gcb = "git checkout -b";
            glo = "git log --oneline";
          }
      ];
    };
  };
}
