{
  inputs.flakelight.url = "github:nix-community/flakelight";
  outputs = { flakelight, ... }@inputs: flakelight ./. {
    inherit inputs;
    packages = {
      zig_master = { lib, zig, fetchFromGitHub, llvmPackages_19 }:
        (zig.overrideAttrs (prevAttrs: rec {
          version = "0.14.0-dev.2262+dceab4502";
          src = fetchFromGitHub {
            owner = "ziglang";
            repo = "zig";
            rev = "dceab4502abf7af6f1ce1a7fa5c9143a46ac8ffa";
            hash = "sha256-y8R9YUOsjxKfIrL3H5IfCMvknInglxdOnHInTbfsBvE=";
          };
          cmakeFlags = prevAttrs.cmakeFlags ++ [
            (lib.cmakeFeature "ZIG_VERSION" version)
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
  };
}
