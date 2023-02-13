set -gx GHQ_SELECTOR sk
set -gx EDITOR nvim
set -gx PROTOC (which protoc-c)
bind \cg '__ghq_repository_search'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__ghq_repository_search'
end
set -gx NIX_PATH \
	darwin=$HOME/.nix-defexpr/channels/darwin \
	darwin-config=$HOME/.nixpkgs/darwin-configuration.nix \
	nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs \
	home-manager=$HOME/.nix-defexpr/channels/home-manager
set -gx PATH $PATH $HOME/.nix-profile/bin $HOME/.volta/bin
eval (starship init fish)
