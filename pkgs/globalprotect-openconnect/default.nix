{ perl
, jq
, fetchFromGitHub
, lib
, openconnect
, libsoup
, webkitgtk
, pkg-config
, vpnc-scripts
, callPackage
, makeDesktopItem
}:
let
    version = "2.3.7";
    pname =  "globalprotect-openconnect";
    naersk = callPackage
    (fetchFromGitHub {
      owner = "nix-community";
      repo = "naersk";
      rev = "3fb418eaf352498f6b6c30592e3beb63df42ef11";
      hash = "sha256-r/xppY958gmZ4oTfLiHN0ZGuQ+RSTijDblVgVLFi1mw=";
    })
    { };

    gpgui = callPackage ./gui.nix { };

    desktop = makeDesktopItem {
        name = "GlobalProtect Openconnect VPN Client";
        desktopName = "GlobalProtect Openconnect VPN Client";
        comment = "A GUI for GlobalProtect VPN";
        genericName = "GlobalProtect VPN Client";
        exec = "gpclient launch-gui %u";
        categories = ["Network" "Dialup"];
        mimeTypes = ["x-scheme-handler/globalprotectcallback"];
    };
in naersk.buildPackage {
    inherit version pname;

    src = fetchFromGitHub {
        owner = "yuezk";
        repo = "GlobalProtect-openconnect";
        rev = "v${version}";
        hash = "sha256-Zr888II65bUjrbStZfD0AYCXKY6VdKVJHQhbKwaY3is=";
    };

        nativeBuildInputs = [
          perl
          jq
          openconnect
          libsoup
          webkitgtk
          pkg-config
        ];

        overrideMain = {...}: {
            patches = [
                ./gui-install.patch
            ];
          postPatch  = ''
            substituteInPlace crates/common/src/vpn_utils.rs \
              --replace-fail /etc/vpnc/vpnc-script ${lib.getExe vpnc-scripts}
            substituteInPlace crates/gpapi/src/lib.rs \
              --replace-fail /usr/bin/gpclient $out/bin/gpclient \
              --replace-fail /usr/bin/gpservice $out/bin/gpservice \
              --replace-fail /usr/bin/gpgui-helper $out/bin/gpgui-helper \
              --replace-fail /usr/bin/gpgui ${gpgui}/bin/gpgui \
              --replace-fail /usr/bin/gpauth $out/bin/gpauth
          '';

          postInstall = ''
            mkdir -p $out/share/applications/
            ln -s ${desktop}/share/applications/* $out/share/applications
            ln -s ${gpgui}/bin/gpgui $out/bin/
          '';
        };

    meta = {
        description = "A GlobalProtect VPN client for Linux, written in Rust, based on OpenConnect and Tauri, supports SSO with MFA, Yubikey, and client certificate authentication, etc.";
        licences = lib.licences.gpl3;
        homepage = "https://github.com/yuezk/GlobalProtect-openconnect";
        maintainers = [
            lib.maintainers.m1dugh
        ];
    };
}
