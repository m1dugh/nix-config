{ stdenv
, fetchgit
, buildGoModule
, ...
}:

let
  src = fetchgit {
    url = "https://opendev.org/openstack/openstack-helm-plugin.git";
    rev = "d2ba2d12811ef2a3338f4b665bd5cccfc744b9c3";
    hash = "sha256-Vz192tprQoEDIWzwzLGONP/9AeTT3Rs+HFz1lCN8wB8=";
  };

  version = "2025-05-03-unstable-0";

  bin = buildGoModule rec {
    pname = "get-values-override";

    inherit src version;
    vendorHash = "sha256-CzZmDiBD4Nc/Ke/+lGWPqgg9+TfspKPMtq2cxXcfWdc=";

    ldflags = [
      "-w"
    ];
  };
in
stdenv.mkDerivation rec {
  name = "helm-osh";
  inherit src version;

  installPhase = ''
    mkdir -p $out/${name}
    install -m0755 wait-for-pods.sh $out/${name}/
    install -m0755 osh.sh $out/${name}/
    cp plugin.yaml $out/${name}/
    ln -s ${bin}/bin/openstack-helm-plugin $out/${name}/get-values-overrides
  '';
}
