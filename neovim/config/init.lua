-- options {{{
vim.opt.wildmenu = true
-- シンタックスハイライトの有効化
-- Neovimはデフォルトで有効化されるはずだがそうならないファイルがある？
vim.opt.syntax = "on"
-- udoファイルを用意
vim.opt.undofile = true
-- デフォルトの折りたたみ方式をmarkerに
vim.opt.foldmethod = "marker"
-- udoの最大値
vim.opt.undolevels = 1024
vim.opt.undoreload = 8192
-- スワップファイルとバックアップファイルを消す
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
-- デフォルトのインデント設定(最初のバッファに設定すると引き継がれる？)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
-- guiと同じく2^24色使えるように(一応)
vim.opt.termguicolors = true
-- 行番号をrelativeumberで表示
vim.opt.number = true
vim.opt.relativenumber = true
-- コマンド欄(下の2行)を2行に設定
vim.opt.cmdheight = 2
-- 検索中のハイライトの有効化
vim.opt.hls = true
-- 不可視文字を可視化
vim.opt.list = true
vim.opt.listchars = "tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%"
-- Coc推奨設定(わからん)
vim.opt.hidden = true
vim.opt.updatetime = 300
-- }}}

require'nvim-treesitter.configs'.setup ({
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
})