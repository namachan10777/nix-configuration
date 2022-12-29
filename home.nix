{ pkgs, ... }: {
  home.packages = [
    pkgs.lazygit
    pkgs.gh
    pkgs.earthly
    pkgs.satysfi
    pkgs.skim
    pkgs.ghq
    pkgs.starship
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
        body = ''
          function __ghq_repository_search -d 'Repository search'
              if type gsed > /dev/null 2>&1
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
      eval (starship init fish)
    '';
  };
}
