{
    withKubernetes ? false,
    historySize ? 100000,
}:
{
    ...
}:
{
    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
            ];
            theme = "robbyrussell";
        };

        history = {
            size = historySize;
            save = historySize;
        };

        initExtra = (if withKubernetes then ''
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
            '' else null);
        shellAliases = (if withKubernetes then {
            k = "kubectl";
        } else {});
    };
}
