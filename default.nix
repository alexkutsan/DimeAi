with import <nixpkgs> {};
crystal.buildCrystalPackage rec {
  pname = "dimeai";
  
  version = "d01754bc2d9738651675922552c037d8e5d016cd";

  src = ./.;
  # src = fetchFromGitHub {
  #   owner = "alexkutsan";
  #   repo = "DimeAI";
  #   rev = version;
  #   hash = "sha256-iMAOaPWlht/m9Wwl5b6S0mnuGcOBlVlZ9C2kO9juiOo=";
  # };

  shardsFile = ./shards.nix;
  format = "crystal";
  crystalBinaries.dimeai.src = "src/main.cr";
  crystalBinaries.dimeai.options = [ "--release" "--verbose" ];
  buildInputs = [
    crystal
    shards
    openssl
    zlib.static
    libevent
    pcre2
    boehmgc
  ];
}