{ pkgs
, ...
}:
pkgs.buildGoModule rec {
  pname = "kubectl-oidc_login";
  version = "v1.29.0";
  src = pkgs.fetchFromGitHub {
    owner = "int128";
    repo = "kubelogin";
    rev = version;
    sha256 = "sha256-fGCllV07YustUIX1XiSvsC42obDOgl2yV5ruQMT2R0c=";
  };

  vendorHash = "sha256-wtxSoRSpmRwuIOdKGmCRR+QLwOvONiiltg6KL6t2cf8=";

  postFixup = ''
    cp $out/bin/kubelogin $out/bin/kubectl-oidc_login
  '';
}
