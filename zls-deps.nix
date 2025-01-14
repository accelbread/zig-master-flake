{ linkFarm, fetchzip }:
linkFarm "zig-packages" [
  {
    name = "12205f5e7505c96573f6fc5144592ec38942fb0a326d692f9cddc0c7dd38f9028f29";
    path = fetchzip {
      url = "https://github.com/ziglibs/known-folders/archive/1cceeb70e77dec941a4178160ff6c8d05a74de6f.tar.gz";
      hash = "sha256-jVqUWsSYm84/8XYTHOdWUuz+RyaMO6BvEtOa9lRGJc8=";
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
    name = "12208e12a10e78de19f140acae65e6edc20189459dd208d5f6b7afdf0aa894113d1b";
    path = fetchzip {
      url = "https://github.com/zigtools/zig-lsp-codegen/archive/e1f281f67ac2cb8c19d3cabe9cfae46fde691c56.tar.gz";
      hash = "sha256-tGsxbGaorBKj11HHlnmKTSHDtPMWk60LoIvRiTRH15M=";
    };
  }
]
