{ pkgs
, lib
, ...
}:
let
  name = "screenshot";
  script = pkgs.writeShellScriptBin name ''
    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe pkgs.ksnip} -e -
  '';
  desktop = pkgs.makeDesktopItem {
    inherit name;
    desktopName = "Screenshot";
    comment = "A screenshot utility tool";
    genericName = "Screenshot";
    categories = [
      "Utility"
    ];
    exec = lib.getExe script;
  };
in
pkgs.stdenv.mkDerivation {
  inherit name;
  version = "0-unstable-2025-03-30";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    ln -s ${lib.getExe script} $out/bin/
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/
    ln -s ${desktop}/share/applications $out/share/applications
  '';

  meta = {
    mainProgram = "screenshot";
  };
}
