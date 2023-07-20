with import <nixpkgs> { };
let
  config = import ./lemurs-config.nix {
    xsessionOption = "";
    xsessionDir = "/var/run/xorg/xsession";
    pkgs = pkgs;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lemurs";
  version = "v0.3.1";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = pname;
    rev = version;
    hash = "sha256-6mNSLEWafw8yDGnemOhEiK8FTrBC+6+PuhlbOXTGmN0=";
  };

  LEMURS_SYSTEM_SHELL = "${pkgs.bash}/bin/bash";

  cargoHash = "sha256-9yZoU0+Z0C2d23yuuwqBqwv4G04QJZe5Gb1TuV3UpME=";
  cargoPatches = [
    ./lemurs-cargo-lock.patch
  ];

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = [
    pkgs.pam
    pkgs.audit
  ];

  postInstall = ''
    mkdir -p $out/etc/lemurs/{wms,wayland}
    cp ${pkgs.writeText "lemurs-config" config.config } $out/etc/lemurs/config.toml
    cp ${pkgs.writeText "lemurs-xsetup" config.xsetup } $out/etc/lemurs/xsetup.sh
  '';

  meta = with lib; {
    description = "A customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = licenses.mit;
    maintainers = [ ];
  };
}
