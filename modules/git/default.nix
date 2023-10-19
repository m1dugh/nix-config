{
    userName ? null,
    userEmail ? null,
    extraConfig ? null,
    editor ? "nvim",
}:
{
    lib,
    ...
}:
{
    programs.git = {
        enable = true;
        userName = userName;
        userEmail = userEmail;

        extraConfig = {
            init.defaultBranch = "master";
            pull.rebase = true;
            core.editor = editor;
            push.autoSetupRemote = true;

            color = {
                ui = "auto";
                branch = "auto";
                diff = "auto";
                interactive = "auto";
                status = "auto";
            };

            commit.verbose = true;
            branch.autosetuprebase = "always";
            push.default = "simple";
            rebase = {
                autoSquash = true;
                autoStash = true;
            };
        };
    };
}
