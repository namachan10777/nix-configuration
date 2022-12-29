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
      (with pkgs;
        vscode-with-extensions.override {
          vscodeExtensions = with vscode-extensions;
            [ ms-vscode-remote.remote-ssh vscodevim.vim ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "satysfi-workshop";
                publisher = "pickoba";
                version = "1.3.0";
                sha256 =
                  "95b3bc2cff177a6f3d1e46b699c9e800899d0cb0c43410cf9920e8ac9fdc74b7";
              }
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
  };
  users.users.namachan.shell = pkgs.nix;
  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;
}
