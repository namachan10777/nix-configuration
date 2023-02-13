{ pkgs, ... }: {
  users.users.namachan = {
    name = "namachan";
    home = "/Users/namachan";
  };
  imports = [ <home-manager/nix-darwin> ];
  home-manager.users.namachan = import ./home.nix;
  environment = {
    loginShell = "/bin/bash";
    systemPackages = [
      pkgs.vim
      pkgs.fish
      pkgs.neovim
      pkgs.gnupg
      pkgs.gnused
      pkgs.meson
      pkgs.ninja
      pkgs.nixfmt
      pkgs.cloudflared
      pkgs.pkg-config
      pkgs.nmap
      pkgs.cmake
    ];
  };
  users.users.namachan.shell = pkgs.nix;
  services.nix-daemon.enable = true;
}
