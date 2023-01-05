set -gx GHQ_SELECTOR sk
set -gx EDITOR nvim
set -gx PROTOC (which protoc-c)
bind \cg '__ghq_repository_search'
if bind -M insert >/dev/null 2>/dev/null
    bind -M insert \cg '__ghq_repository_search'
end
eval (starship init fish)
