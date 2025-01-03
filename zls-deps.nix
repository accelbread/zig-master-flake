{ linkFarm, fetchzip }:
linkFarm "zig-packages" [
  {
    name = "1220102cb2c669d82184fb1dc5380193d37d68b54e8d75b76b2d155b9af7d7e2e76d";
    path = fetchzip {
      url = "https://github.com/ziglibs/diffz/archive/ef45c00d655e5e40faf35afbbde81a1fa5ed7ffb.tar.gz";
      hash = "sha256-5/3W0Xt9RjsvCb8Q4cdaM8dkJP7CdFro14JJLCuqASo=";
    };
  }
  {
    name = "122022a478dccaed1309fb5d022f4041eec45d40c93a855ed24fad970774c2426d91";
    path = fetchzip {
      url = "https://github.com/wolfpld/tracy/archive/refs/tags/v0.11.1.tar.gz";
      hash = "sha256-HofqYJT1srDJ6Y1f18h7xtAbI/Gvvz0t9f0wBNnOZK8=";
    };
  }
  {
    name = "122054fe123b819c1cca154f0f89dd799832a639d432287a2371499bcaf7b9dcb7a0";
    path = fetchzip {
      url = "https://github.com/zigtools/zig-lsp-codegen/archive/6b34887189def7c859307f4a9fc436bc5f2f04c9.tar.gz";
      hash = "sha256-008pUPFGDaB9iXAhqKw4ON457EGzbfhH3G97tCMZfic=";
    };
  }
  {
    name = "12205f5e7505c96573f6fc5144592ec38942fb0a326d692f9cddc0c7dd38f9028f29";
    path = fetchzip {
      url = "https://github.com/ziglibs/known-folders/archive/1cceeb70e77dec941a4178160ff6c8d05a74de6f.tar.gz";
      hash = "sha256-jVqUWsSYm84/8XYTHOdWUuz+RyaMO6BvEtOa9lRGJc8=";
    };
  }
]
