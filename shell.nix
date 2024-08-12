with (import <nixpkgs> {});
mkShell {
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