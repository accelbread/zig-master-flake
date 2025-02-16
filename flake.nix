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
          version = "0.14.0-dev.3237+ddff1fa4c";
          src = fetchFromGitHub {
            owner = "ziglang";
            repo = "zig";
            rev = "ddff1fa4c6cb80363a2c2a34fd5eace95be585d4";
            hash = "sha256-pJkQ0sEIuH8K0VBi9LZB58rfbhv1Cbxhm/8/Hx4HA/k=";
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
          version = "0.14.0-dev+188a4c04b";
          src = fetchFromGitHub {
            owner = "zigtools";
            repo = "zls";
            rev = "188a4c04bef66a29534eb2059f9d6c3c5ed10bd8";
            hash = "sha256-b5HvgkHV7lElyZr9mg2ulj5mtczrkM8qklcX9ILN7wg=";
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
