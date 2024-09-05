{ pkgs
, ...
}@inputs: {
  waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer inputs;
  multimc = pkgs.callPackage ./multimc inputs;
  kubelogin = pkgs.callPackage ./kubelogin.nix inputs;
}
