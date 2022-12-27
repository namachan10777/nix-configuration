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
          [ ms-vscode-remote.remote-ssh vscodevim.vim ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "Nix";
              publisher = "bbenoist";
              version = "1.0.1";
              sha256 =
                "ab0c6a386b9b9507953f6aab2c5f789dd5ff05ef6864e9fe64c0855f5cb2a07d";
            }
            {
              name = "remote-ssh-edit";
              publisher = "ms-vscode-remote";
              version = "0.47.2";
              sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
            }
          ];
      })
  ];
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}