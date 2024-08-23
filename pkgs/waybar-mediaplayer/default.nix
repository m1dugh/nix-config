{ pkgs
, lib
, ...
}: 
let
    pythonPackages = pkgs.python311Packages;
in pkgs.stdenv.mkDerivation rec {
    name = "waybar-mediaplayer";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
        owner = "raffaem";
        repo = name;
        rev = "master";
        sha256 = "sha256-4pu0BYOyh37xhwlObycAszn6o0AcZwf0HCg7O7V7oAI=";
    };

    nativeBuildInputs = with pythonPackages; [
        wrapPython
    ];

    propagetedBuildInputs = [
        pkgs.python311
        pkgs.playerctl
    ];

    pythonPath = with pythonPackages; [
        pillow
        pycairo
        syncedlyrics
        pygobject3
    ];

    configurePhase = ''
        mkdir -p $out/bin/
        mkdir -p $out/share/
    '';

    installPhase = ''
        install -m 0755 $src/src/mediaplayer $out/bin/waybar-mediaplayer
    '';

    fixupPhase = ''
        patch $out/bin/waybar-mediaplayer ${./patch}
        runHook postFixup
    '';

    postFixup = ''
        wrapPythonPrograms
        autoPatchelfHook
    '';

    metadata = {
        maintainers = with lib.maintainers; [
            m1dugh
        ];
    };
}
