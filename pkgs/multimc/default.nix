{ pkgs
, lib
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp -R $src/bin/* $out/bin/

     mkdir -p $out/share/applications
     ln -s ${desktop}/share/applications/* $out/share/applications

    runHook postInstall
  '';

  buildInputs = with pkgs; [
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];

  propagatedNativeBuildInputs = with pkgs; [
    temurin-jre-bin
  ];

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    libsForQt5.qt5.qtbase
  ];

  qtWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath buildInputs}"''
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  postFixup = ''
    makeShellWrapper "$out/bin/MultiMC" "$out/bin/multimc" \
        --prefix PATH : ${pkgs.temurin-jre-bin}/bin \
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
