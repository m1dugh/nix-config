{ config, pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
  ];
  fonts.fontDir.enable = true;
}
