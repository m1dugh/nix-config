{ pkgs
, ...
}:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
    pulseaudio = true;
  };

  time.timeZone = "Europe/Paris";

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    vim
    zsh

    python311
    poetry

    wget
    curl
    killall
    htop
    pciutils

    # Documentation
    man-pages
    man-pages-posix

    dig
    inetutils
  ];

  documentation.dev.enable = true;

  programs.zsh.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-emoji
    liberation_ttf

    font-awesome_6
    material-symbols
  ];

  environment.shells = with pkgs; [ zsh ];

  environment.variables = {
    TERMINAL = "alacritty";
    EDITOR = "vim";
    VISUAL = "vim";
  };

}
