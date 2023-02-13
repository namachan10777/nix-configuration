{ pkgs, stdenv, ... }: {
  nixpkgs.config.allowUnfree = true;
  home.username = "namachan";
  home.packages = [
    pkgs.lazygit
    pkgs.gh
    pkgs.earthly
    pkgs.satysfi
    pkgs.skim
    pkgs.ghq
    pkgs.starship
    pkgs.act
    pkgs.protobufc
    pkgs.opam
    (with pkgs;
      vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions;
          [
            ms-vscode-remote.remote-ssh
            vscodevim.vim
            tomoki1207.pdf
            rust-lang.rust-analyzer
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "proto";
              publisher = "peterj";
              version = "0.0.2";
              sha256 = "9c0e43c91ff1b67231743d12ea5809fa5b34cf544948a064158cfb7f6ae3df11";
            }
            {
              name = "prettyxml";
              publisher = "PrateekMahendrakar";
              version = "3.0.1";
              sha256 =
                "76f4bd4cf35f7e0d088e795b923e8cf8fdb57c7f274f69b36e16ceb95f9c92f6";
            }
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
  home.stateVersion = "22.11";
  programs.starship = { enable = true; };
  programs.neovim = {
    enable = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    extraConfig = ''
      :luafile ~/.config/nvim/init.lua
    '';
  };
  xdg.configFile.nvim = {
    source = ./neovim/config;
    recursive = true;
  };
  programs.fish = {
    enable = true;
    shellAbbrs = {
      lg = "lazygit";
      v = "nvim";
    };
    functions = {
      __ghq_repository_search = {
        body = builtins.readFile ./fish/__ghq_repository_search.fish;
      };
    };
    shellInit = builtins.readFile ./fish/init.fish;
  };
}
