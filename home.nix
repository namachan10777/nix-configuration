{ pkgs, stdenv, ... }: rec {
  nixpkgs.config.allowUnfree = true;
  home.username = "namachan";
  home.homeDirectory =
    if pkgs.system == "x86_64-linux" then "/home/${home.username}"
    else if pkgs.system == "aarch64-darwin" then "/Users/${home.username}"
    else "/tmp/${home.username}";
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
    pkgs.nixpkgs-fmt
    pkgs.gnupg
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
            version = "0.0.4";
            sha256 = "3bccfd54fad1fe2f3749e4f5705ea916215034bbb6e4d9904aef4d0328e82f0c";
          }
          {
            name = "prettyxml";
            publisher = "PrateekMahendrakar";
            version = "3.4.0";
            sha256 =
              "24e3521956a5b4ebb87b78e075f5e5cdf28b4329868f69e04586897814f45230";
          }
          {
            name = "satysfi-workshop";
            publisher = "pickoba";
            version = "1.4.0";
            sha256 =
              "0e0cc473138210828ca5b70fee52f93d3839432081ad6e9d4358b2a439af3727";
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
            version = "0.86.0";
            sha256 = "26c6daa087a4528da7282bbe7cd6c6961e5dd53b7f409194b975063f4e13b032";
          }
        ];
    })
  ];
  home.stateVersion = "23.05";
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
  programs.git = {
    enable = true;
    userName = "Masaki.Nanakno";
    userEmail = "admin@namachan10777.dev";
    extraConfig = {
      ghq.root = "~/Project";
    };
  };
  programs.fish = {
    enable = true;
    shellAbbrs = {
      lg = "lazygit";
      v = "nvim";
      ev = "envchain";
    };
    functions = {
      __ghq_repository_search = {
        body = builtins.readFile ./fish/__ghq_repository_search.fish;
      };
    };
    shellInit = builtins.readFile ./fish/init.fish;
  };
}
