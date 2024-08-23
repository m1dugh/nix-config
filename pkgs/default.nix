{ pkgs
, ...
}@inputs: {
    waybar-mediaplayer = pkgs.callPackage ./waybar-mediaplayer inputs;
}
