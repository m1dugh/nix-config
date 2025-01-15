{ pkgs
, ...
}@inputs: {
  waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer inputs;
  screenshot = pkgs.callPackage ./screenshot.nix inputs;
  inwebo-authenticator = pkgs.callPackage ./inwebo-authenticator.nix inputs;
  globalprotect-openconnect_2 = pkgs.callPackage ./globalprotect-openconnect {
    withGui = true;
  };
  gpgui = pkgs.callPackage ./globalprotect-openconnect/gui.nix {
    version = "2.4.1";
    platforms = [
        "aarch64-linux"
        "x86_64-linux"
    ];
    maintainers = [ ];
  };
}
