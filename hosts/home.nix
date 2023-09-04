{
    config,
    lib,
    pkgs,
    home-manager,
    username,
    ...
}:
{
    home = {
        username = "${username}";
        homeDirectory = "/home/${username}";

        packages = with pkgs; [
            git-lfs
            playerctl
            gparted
            virt-manager
        ];

        stateVersion = "23.11";
    };

    programs.git = {
        enable = true;
        userName = "m1dugh";
        userEmail = "romain.le-miere@epita.fr";

        extraConfig = {
            init.defaultBranch = "master";
            pull.rebase = true;
            core.editor = "nvim";
            push.autoSetupRemote = true;
        };
    };

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
            ];
            theme = "robbyrussell";
        };

        history = 
        let history_size = 100000;
        in {
            size = history_size;
            save = history_size;
        };

        initExtra = ''
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
            '';
        shellAliases = {
            k = "kubectl";
        };
    };

    programs.home-manager.enable = true;

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
    };

}
