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

    withLoadenv = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to add the loadenv script to zsh.
      '';
    };

    extraScripts = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        A list of scripts to add as strings
      '';
      example = litteralExpression ''
        "function test() {echo \"test\"}"
      '';
    };
  };

  config =
    let
      extraScripts = cfg.extraScripts ++ (builtins.filter (val: val != null) [
        (strings.optionalString cfg.withLoadenv ''
          function loadenv () {
              if [ $# -le 0 ]; then
                  echo "Usage: loadenv <files> ..." >&2
                  return 1
              fi
              set -o allexport
              for file in "$@"; do
                  source "$file"
              done
              set +o allexport
          }
        '')
        (strings.optionalString cfg.withKubernetes ''
          source <(kubectl completion zsh)
        '')
        (strings.optionalString cfg.viMode ''
          bindkey -v
          export KEYTIMEOUT=1
          bindkey -M menuselect 'h' vi-backward-char
          bindkey -M vicmd 'k' up-line-or-beginning-search
          bindkey -M menuselect 'l' vi-forward-char
          bindkey -M vicmd 'j' down-line-or-beginning-search
          '')
        ''
        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "$terminfo[kcuu1]" up-line-or-beginning-search # Up
        bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down
        ''
      ]);
    in
    mkIf cfg.enable {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history = {
          size = cfg.historySize;
          save = cfg.historySize;
        };

        initExtra = strings.concatStringsSep "\n" ([
          ''
            ZSH_CACHE_DIR=''${ZSH_CACHE_DIR:-~/.config/zsh/}

            zmodload zsh/complist
            bindkey '^E' autosuggest-accept
            bindkey '^[[1;5C' forward-word
            bindkey '^[[1;5D' backward-word
            fpath=(${./prompt} $fpath)
            autoload -Uz prompt_custom_setup && prompt_custom_setup
          ''

        ] ++ extraScripts);
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
