{
  pkgs,
  ...
}@inputs:
{
  waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer inputs;
  screenshot = pkgs.callPackage ./screenshot.nix inputs;
  inwebo-authenticator = pkgs.callPackage ./inwebo-authenticator.nix inputs;

  helm-osh = pkgs.callPackage ./helm-osh { };
}
