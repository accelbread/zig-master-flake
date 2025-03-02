{ linkFarm, fetchzip }:
linkFarm "zig-packages" [
  {
    name = "known_folders-0.0.0-Fy-PJtLDAADGDOwYwMkVydMSTp_aN-nfjCZw6qPQ2ECL";
    path = fetchzip {
      url = "https://github.com/ziglibs/known-folders/archive/aa24df42183ad415d10bc0a33e6238c437fc0f59.tar.gz";
      hash = "sha256-YiJ2lfG1xsGFMO6flk/BMhCqJ3kB3MnOX5fnfDEcmMY=";
    };
  }
  {
    name = "1220102cb2c669d82184fb1dc5380193d37d68b54e8d75b76b2d155b9af7d7e2e76d";
    path = fetchzip {
      url = "https://github.com/ziglibs/diffz/archive/ef45c00d655e5e40faf35afbbde81a1fa5ed7ffb.tar.gz";
      hash = "sha256-5/3W0Xt9RjsvCb8Q4cdaM8dkJP7CdFro14JJLCuqASo=";
    };
  }
  {
    name = "lsp_codegen-0.1.0-CMjjo0ZXCQB-rAhPYrlfzzpU0u0u2MeGvUucZ-_g32eg";
    path = fetchzip {
      url = "https://github.com/zigtools/zig-lsp-codegen/archive/063a98c13a2293d8654086140813bdd1de6501bc.tar.gz";
      hash = "sha256-KzRi/a3FCS11Mryin9skkf3rFrIuoMP8+RcU0IuYNBA=";
    };
  }
]
