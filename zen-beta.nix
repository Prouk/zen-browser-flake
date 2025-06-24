{
  stdenv,
  version,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "Zen Browser (${version.beta.tag_name})";
  src = fetchurl {
    url = version.beta.browser_download_url;
    hash = version.beta.digest;
  };
  
}
