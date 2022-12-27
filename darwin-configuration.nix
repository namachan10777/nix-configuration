{ pkgs, ... }: {
  users.users.namachan = {
    name = "namachan";
    home = "/Users/namachan";
  };
  imports = [ <home-manager/nix-darwin> ];
  home-manager = {
    users.namachan = { pkgs, ... }: {
      home.packages =
        [ pkgs.lazygit pkgs.gh pkgs.earthly pkgs.satysfi pkgs.skim pkgs.ghq ];
      home.stateVersion = "23.05";
      programs.fish = {
        enable = true;
        shellAbbrs = {
          lg = "lazygit";
          v = "nvim";
        };
        functions = {
          __ghq_repository_search = {
            body = ''
              function __ghq_repository_search -d 'Repository search'
                  if type gsed /dev/null 2>&1
                      set SED gsed
                  else
                      set SED sed 
                  end

                  set -l selector
                  [ -n "$GHQ_SELECTOR" ]; and set selector $GHQ_SELECTOR; or set selector fzf
                  set -l selector_options
                  [ -n "$GHQ_SELECTOR_OPTS" ]; and set selector_options $GHQ_SELECTOR_OPTS

                  if not type -qf $selector
                      printf "\nERROR: '$selector' not found.\n"
                      exit 1
                  end

                  set -l query (commandline -b)
                  [ -n "$query" ]; and set flags --query="$query"; or set flags
                  switch "$selector"
                      case fzf fzf-tmux peco percol fzy sk
                          ghq list --full-path | $SED -e "1i"$HOME"/Downloads\n"$HOME"/tmp" | eval "$selector" $selector_options $flags | read select
                      case \*
                          printf "\nERROR: plugin-ghq is not support '$selector'.\n"
                  end
                  [ -n "$select" ]; and cd "$select"
                  commandline -f repaint
              end
            '';
          };
        };
        shellInit = ''
          set -gx GHQ_SELECTOR sk
          set -gx EDITOR nvim
          bind \cg '__ghq_repository_search'
          if bind -M insert >/dev/null 2>/dev/null
            bind -M insert \cg '__ghq_repository_search'
          end
        '';
      };
    };
  };
  environment = {
    systemPackages = [
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
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
