{
  appimageTools,
  fetchurl,
  ...
}:
let
  pname = "inwebo-authenticator";
  version = "0-unstable-2024-09-16";
  src = fetchurl {
    url = "https://download.trustbuilder.com/wp-content/uploads/Authenticator6-Linux.AppImage";
    sha256 = "sha256-4FeW6N3PByr8owPrAikxUQtZ3emubmToEsutjMxYTHM=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
}
