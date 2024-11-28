{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    nixpkgs.follows = "flakelight/nixpkgs";
  };
  outputs = { flakelight, ... }@inputs: flakelight ./. {
    inherit inputs;
    packages = {
      zig_master = { inputs', system, lib, fetchFromGitHub, llvmPackages_19 }:
        (inputs'.nixpkgs.legacyPackages.zig.overrideAttrs (prevAttrs: rec {
          version = "0.14.0-dev.2262+dceab4502";
          src = fetchFromGitHub {
            owner = "ziglang";
            repo = "zig";
            rev = "dceab4502abf7af6f1ce1a7fa5c9143a46ac8ffa";
            hash = "sha256-y8R9YUOsjxKfIrL3H5IfCMvknInglxdOnHInTbfsBvE=";
          };
          cmakeFlags = [
            (lib.cmakeFeature "ZIG_VERSION" version)
            (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
            (lib.cmakeBool "ZIG_STATIC_LLVM" true)
            (lib.cmakeFeature "ZIG_TARGET_MCPU"
              (if system == "x86_64-linux" then "x86_64_v3" else "baseline"))
          ];
          postBuild = ''
            stage3/bin/zig build docs --zig-lib-dir "$PWD/stage3/lib/zig"
          '';
          postInstall = ''
            mkdir -p $doc/share/doc/zig-${version}
            cp -r ../zig-out/doc $doc/share/doc/zig-${version}/html
          '';
        })).override { llvmPackages = llvmPackages_19; };
      zls_master = { stdenv, zig_master, fetchFromGitHub, callPackage }:
        stdenv.mkDerivation (finalAttrs: {
          pname = "zls";
          version = "d120457";
          src = fetchFromGitHub {
            owner = "zigtools";
            repo = "zls";
            rev = "d120457b19a72e7605a7bacd74620cd9683f4527";
            hash = "sha256-GeZm3UXXG98KS6Tk57lC5jMD0mgzdjO4UqOn8frZQak=";
          };
          nativeBuildInputs = [ zig_master.hook ];
          postPatch = ''
            ln -s ${callPackage ./zls-deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
          '';
        });
    };
    overlays = { lib, outputs, ... }: {
      override-zig = lib.composeExtensions outputs.overlays.default
        (final: prev: {
          zig = final.zig_master;
          zls = final.zls_master;
        });
    };
  };
}
