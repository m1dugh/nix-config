{ pkgs
, lib
, withWayland ? true
, ...
}:
with lib;
let
  desktop = pkgs.makeDesktopItem {
    name = "MultiMC";
    desktopName = "MultiMC";
    comment = "A minecraft launcher";
    genericName = "A minecraft launcher";
    categories = [ "Game" ];
    exec = "multimc";
  };
  javaLibs = (
    (lists.singleton pkgs.libGL)
    ++ (lists.optional withWayland pkgs.glfw-wayland-minecraft)
  );
in
pkgs.stdenv.mkDerivation rec {
  name = "multimc";
  version = "1.0.0";

  src =
    let
      distro = "lin";
      arch = "64";
    in
    builtins.fetchTarball {
      inherit name;
      sha256 = "0dsjiqjv3pcnccapshmp8mg9bxy0l4s75zf8waknqiy02qsy3sbb";
      url = "https://files.multimc.org/downloads/mmc-develop-${distro}${arch}.tar.gz";
    };

  installPhase =
    let
      copyLib = pkg: "ln -sf ${pkg}/lib/* $out/lib";
      extraLibs = strings.concatStringsSep "\n" (map copyLib javaLibs);
    in
    ''
      runHook preInstall

      mkdir -p $out/bin/
      cp -R $src/bin/* $out/bin/

       mkdir -p $out/share/applications
       ln -s ${desktop}/share/applications/* $out/share/applications

       mkdir -p $out/lib/
       ${extraLibs}

       runHook postInstall
    '';

  libraryPath = with pkgs; [
    libsForQt5.qt5.qtbase
  ];

  propagatedBuildInputs = libraryPath;

  propagatedNativeBuildInputs = with pkgs; [
    temurin-jre-bin
  ] ++ javaLibs;

  nativeBuildInputs = with pkgs; [
    makeWrapper
    libsForQt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  qtWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraryPath}"''
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  postFixup = ''
    makeShellWrapper "$out/bin/MultiMC" "$out/bin/multimc" \
        --prefix PATH : ${pkgs.temurin-jre-bin}/bin \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath javaLibs} \
        --set JAVA_TOOL_OPTIONS -Djava.library.path=test \
        --add-flags '--dir $HOME/.multimc'
  '';

  meta = {
    maintainers = with maintainers; [
      m1dugh
    ];
    description = "A launcher for minecraft";
    homepage = "https://multimc.org/";

    platforms = platforms.linux;
  };
}
