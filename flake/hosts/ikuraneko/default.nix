{ pkgs, lib, inputs, ... }: {
  security.pam.enableSudoTouchIdAuth = true;
  services.nix-daemon.enable = true;
  programs.fish.enable = true;
  nixpkgs.config.allowUnfree = true;
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
    ];
  };
}
