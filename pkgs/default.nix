{ pkgs
, ...
}@inputs: {
  waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer inputs;
  multimc = pkgs.callPackage ./multimc inputs;
  msi-ec = pkgs.callPackage ./msi-ec inputs;
  screenshot = pkgs.callPackage ./screenshot.nix inputs;
  inwebo-authenticator = pkgs.callPackage ./inwebo-authenticator.nix inputs;
  globalprotect-openconnect_2 = pkgs.callPackage ./globalprotect-openconnect {
    withGui = true;
  };
}
