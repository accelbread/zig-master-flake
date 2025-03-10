{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    nixpkgs.follows = "flakelight/nixpkgs";
  };
  outputs = { flakelight, ... }@inputs: flakelight ./. ({ outputs, ... }: {
    inherit inputs;
    packages = {
      zig_master = { inputs', system, lib, fetchFromGitHub, llvmPackages_19 }:
        (inputs'.nixpkgs.legacyPackages.zig.overrideAttrs (prevAttrs: rec {
          version = "0.14.0-dev.3452+0367d684f";
          src = fetchFromGitHub {
            owner = "ziglang";
            repo = "zig";
            rev = "0367d684fccf8bf011fe8ac1a984820c824871a8";
            hash = "sha256-R5aTffj48dn3YxXZsHxs9t8xtmm2F9h4s6spAeWkAMg=";
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
          version = "0.14.0-dev+336f468c1";
          src = fetchFromGitHub {
            owner = "zigtools";
            repo = "zls";
            rev = "336f468c1fddbb8b7356946f4f2ee69434edfaad";
            hash = "sha256-/8kHE/4JIPcslLO3L1ClqVukXvQvkMEd5m8ZUkRQPFI=";
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
    flakelightModule = {
      withOverlays = [ outputs.overlays.default ];
      zigToolchain = pkgs: { zig = pkgs.zig_master; zls = pkgs.zls_master; };
    };
  });
}
