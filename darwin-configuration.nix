{ pkgs, ... }: {
  users.users.namachan = {
    name = "namachan";
    home = "/Users/namachan";
  };
  imports = [ <home-manager/nix-darwin> ];
  home-manager.users.namachan = { pkgs, ... }: {
    home.packages = [ pkgs.lazygit ];
    home.stateVersion = "23.05";
    programs.fish.enable = true;
  };
  environment.systemPackages = [
    pkgs.vim
    pkgs.fish
    pkgs.neovim
    pkgs.gnupg
    pkgs.gnused
    pkgs.meson
    pkgs.ninja
    pkgs.nixfmt
    (with pkgs;
      vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions;
          [ ms-vscode-remote.remote-ssh ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }];
      })
  ];
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
