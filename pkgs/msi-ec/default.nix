{ stdenv
, lib
, fetchFromGitHub
, linuxPackages
, kernel ? linuxPackages.kernel
, ...
}:
stdenv.mkDerivation rec {
	pname = "msi-ec-kmods";
	version = "0.09";

	src = fetchFromGitHub {
		owner = "m1dugh";
		repo = "msi-ec";
		rev = "60aad95e2c8948140232f4c4d70f4ceba821d5a5";
		hash = "sha256-qgM4KeGoLvbVsii5YR3GTGi2MVlU+JeArzEoA+6A3a0=";
	};

    dontMakeSourcesWritable = false;

    patchPhase = ''
        cp ${./patches/Makefile} ./Makefile
    '';

	hardeningDisable = [
		"pic"
	];

    KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

	makeFlags = kernel.makeFlags ++ [
        "KERNELDIR=${KERNELDIR}"
		"INSTALL_MOD_PATH=$(out)"
	];

	nativeBuildInputs = kernel.moduleBuildDependencies;

    buildFlags = [ "modules" ];
    installTargets = [ "modules_install" ];

	enableParallelBuilding = true;

	meta = with lib; {
		description = "Kernel modules for MSI Embedded controller";
		homepage = "https://github.com/BeardOverflow/msi-ec";
		license = licenses.gpl2;
		maintainers = [];
		platforms = platforms.linux;
	};
}
