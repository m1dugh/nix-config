
{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.midugh = {
    gid = 1000;
  };
  users.users.midugh = {
    shell = pkgs.zsh;
    isNormalUser = true;
    group = "midugh";
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        krb5
        sshfs
        git-lfs
        imagemagick
        firefox
        brave
        discord
        playerctl
        gparted
        virt-manager
      ];
  };
}
