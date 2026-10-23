-- Options: basics that just make life better
local opt = vim.opt

opt.number = true
opt.relativenumber = true        -- easy jumps: 5j 12k
opt.cursorline = true
opt.signcolumn = "yes"           -- no text shift when LSP/git signs appear
opt.colorcolumn = "80"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
opt.background = "dark"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

opt.splitbelow = true
opt.splitright = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"    -- system clipboard
opt.undofile = true              -- persistent undo
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.updatetime = 250             -- faster CursorHold, better LSP hover
opt.timeoutlen = 400             -- faster which-key popup
opt.completeopt = { "menuone", "noselect", "noinsert" }
opt.pumheight = 12

opt.wildmenu = true
opt.showmode = false             -- lualine shows mode already
opt.laststatus = 3               -- single global statusline

-- Folding with treesitter (opened by default)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Format on save for LSP clients (toggle with <leader>uf)
vim.g.format_on_save = true
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  callback = function()
    if vim.g.format_on_save then
      vim.lsp.buf.format({ async = false })
    end
  end,
})
