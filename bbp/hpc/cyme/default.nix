{ config, stdenv, fetchgitExternal, boost, cmake, pandoc }:

stdenv.mkDerivation rec {
  name = "cyme-${version}";
  version = "1.6.0-201704";
  meta = {
    description = "facilitate SIMD programming";
    homepage = https://github.com/BlueBrain/cyme;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with config.maintainers; [
      timocafe
    ];
  };

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "eb4734b8a5c183027c4bb9a2cd4947fbc59ec8d5";
    sha256 = "1ji8wn6wwwk6gc8l04i2cx55w051ia7r6pw4lrjxs11zb5s5cwmd";
  };

  buildInputs = [ stdenv boost cmake ];
  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = ''
    mkdir -p $out/share/doc/cyme/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/cyme/html/index.html
  '';
  outputs = [ "out" "doc" ];
}
