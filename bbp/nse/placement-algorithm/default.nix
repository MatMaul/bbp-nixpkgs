{
  stdenv,
  config,
  fetchgitPrivate,
  boost,
  python,
  pythonPackages,
  brainbuilder,
  voxcell
}:


let
  python-env = python.buildEnv.override {
    extraLibs = [
      pythonPackages.numpy
      pythonPackages.requests
      brainbuilder
      voxcell
    ];
  };

in

stdenv.mkDerivation rec {
  name = "placement-algorithm-${version}";
  version = "2018.02.13-${stdenv.lib.substring 0 6 src.rev}";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "22a030e90a612ae01594c43e3d88ed6710009013";
    sha256 = "1dj1x08axsywy8hjv6h2q8agrrbbphf5wx30jd8w5a1jvv7iahsk";
  };

  buildInputs = [
    boost
    stdenv
    python-env
    pythonPackages.nose
  ];

  doCheck = true;
  checkTarget = "test";

  installFlags = "PREFIX=$(out)";

  postInstall = ''
    LAUNCHER="$out/bin/assign-morphologies"
    cat << EOF > "$LAUNCHER"
    export PYSPARK_PYTHON=${python-env.interpreter}
    export PYSPARK_DRIVER_PYTHON=${python-env.interpreter}
    spark-submit "$out/share/pyspark/assign_morphologies.py" \$@
    EOF
    chmod +x "$LAUNCHER"
  '';
}
