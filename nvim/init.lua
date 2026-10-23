-- Basic but useful Neovim config (Lua + lazy.nvim)
-- Leader must be set BEFORE lazy loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = { notify = false },
  checker = { enabled = false }, -- run :Lazy update manually
})

-- Beauty: colorscheme (loaded via lazy, but fallback safe)
pcall(vim.cmd.colorscheme, "tokyonight-night")

-- 100% прозрачный фон (после colorscheme!)
require("transparent")
