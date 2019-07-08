# used temporarily to install tabnine, until 56250 is merged

{ stdenv, lib, fetchurl }:

let
  platformSpecific = {
    x86_64-linux = {
      sha256 = "9e55a64a0362350fc82080f602749f6e2899e95ea1751de98f0f1d3dac5cb2d1";
      string = "x86_64-unknown-linux-gnu";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported platform");
in
stdenv.mkDerivation rec {
  pname = "tabnine";
  version = "1.0.14";

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

  postFixup = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${stdenv.cc.libc}/lib:${stdenv.cc.cc.lib}/lib" $out/bin/TabNine
  '';

  meta = with stdenv.lib; {
    description = "TabNine is the all-language autocompleter. It uses machine learning to provide responsive, reliable, and relevant suggestions.";
    homepage = https://tabnine.com/;
    license = stdenv.lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
