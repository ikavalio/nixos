# used temporarily to install tabnine, until 56250 is merged

{ stdenv, lib, fetchurl }:

let
  platformSpecific = {
    x86_64-linux = {
      sha256 = "1k59cdciy7lnash0fnkv97bcg3i99q8v0b64zv0vvp4mxzsrsgvk";
      string = "x86_64-unknown-linux-gnu";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported platform");
in
stdenv.mkDerivation rec {
  pname = "tabnine";
  version = "2.1.17";

  src = fetchurl {
    inherit (platformSpecific) sha256;
    url = "https://update.tabnine.com/${version}/${platformSpecific.string}/TabNine";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/TabNine
    chmod +x $out/bin/TabNine
  '';

  meta = with stdenv.lib; {
    description = "TabNine is the all-language autocompleter. It uses machine learning to provide responsive, reliable, and relevant suggestions.";
    homepage = https://tabnine.com/;
    license = stdenv.lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
