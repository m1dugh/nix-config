{
  config,
  pkgs,
  home-manager,
  username,
  ...
}@inputs:
let configRoot = "../../configs";
in {

  manual.manpages.enable = false;
  home.username = "romain.le-miere";
  home.homeDirectory = "/home/romain.le-miere";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    rofi
    picom
    alacritty
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.packer-nvim
    ];
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];

      theme = "robbyrussel";
    };
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export SHELL=zsh;
    '';
  };

  programs.alacritty = {
    enable = true;
  };

  home.file = {
    ".vimrc".source = ./. + "${configRoot}/vimrc";
    ".config/nvim" = {
      recursive = true;
      source = ./. + "${configRoot}/nvim";
    };
  };
}
