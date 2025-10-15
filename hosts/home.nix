{
  pkgs,
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
  };
}
