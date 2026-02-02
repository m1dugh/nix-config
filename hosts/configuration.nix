{
  pkgs,
  lib,
  ...
}:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
    pulseaudio = true;
  };

  time.timeZone = lib.mkDefault "Europe/Paris";

  networking.nftables.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  environment.shells = with pkgs; [ zsh ];

  environment.variables = {
    TERMINAL = "alacritty";
    EDITOR = "vim";
    VISUAL = "vim";
  };

}
