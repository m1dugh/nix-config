{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.midugh.zsh;
  completionModuleOption = {
    options = {
      command = mkOption {
        description = "The command to run for the completion";
        example = literalExpression ''
          # source <(${pkgs.kubectl}/bin/kubectl completion zsh)
        '';
        type = types.str;
      };

      enable = mkOption {
        description = "Whether to enable the option";
        default = true;
        type = types.bool;
      };
    };
  };
in
{
  options.midugh.zsh = {
    enable = mkEnableOption "zsh default config";

    historySize = mkOption {
      type = types.int;
      default = 100000;
      description = "The size of the history";
    };

    useLsd = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use the lsd command instead of ls and tree";
    };

    viMode = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable vim mode";
    };

    completions = mkOption {
      type = types.attrsOf (types.submodule completionModuleOption);
      default = { };
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

  config = mkIf cfg.enable {

    midugh.zsh.completions = mkDefault {
      "kubectl".command = "source <(kubectl completion zsh)";
      "docker".command = "source <(docker completion zsh)";
    };

    home.packages = (lists.optional cfg.useLsd pkgs.lsd);

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = cfg.historySize;
        save = cfg.historySize;
      };

      initContent =
        let
          completionsScripts =
            let
              values = builtins.attrValues cfg.completions;
            in
            builtins.filter (v: v.enable) values;
          extraScripts =
            cfg.extraScripts
            ++ (builtins.map (s: s.command) completionsScripts)
            ++ (builtins.filter (val: val != null) [
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
        strings.concatStringsSep "\n" (
          [
            ''
              ZSH_CACHE_DIR=''${ZSH_CACHE_DIR:-~/.config/zsh/}

              zmodload zsh/complist
              bindkey '^E' autosuggest-accept
              bindkey '^[[1;5C' forward-word
              bindkey '^[[1;5D' backward-word
              fpath=(${./prompt} $fpath)
              autoload -Uz prompt_custom_setup && prompt_custom_setup
            ''

          ]
          ++ extraScripts
        );
      shellAliases =
        {
          k = "kubectl";
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
        // (
          if cfg.useLsd then
            {
              ls = "lsd";
              tree = "lsd --tree";
            }
          else
            { }
        );
    };
  };
}
