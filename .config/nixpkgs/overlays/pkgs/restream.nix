{ stdenv, pkgconfig, autoreconfHook, libpng, libjpeg, libXpm, pixman, xcbutil, xcbutilimage, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "xwallpaper-${version}";
  version = "v0.5.0";
  sha256 = "074iaqc7hl34p48pp5gcibwls4pvzc4zll5adfhq6bi0gj459fay";

  src = fetchFromGitHub {
    owner = "stoeckmann";
    repo = "xwallpaper";
    rev = "${version}";
    sha256 = "${sha256}";
  };

  nativeBuildInputs = [ pkgconfig libjpeg libpng libXpm pixman xcbutil xcbutilimage autoreconfHook ];
}
