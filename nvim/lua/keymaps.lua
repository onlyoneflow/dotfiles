-- Keymaps: <leader> = Space. See all with <leader>? (which-key)
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better escape / save / quit
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>w", "<cmd>w<cr>", vim.tbl_extend("force", opts, { desc = "Save file" }))
map("n", "<leader>q", "<cmd>q<cr>", vim.tbl_extend("force", opts, { desc = "Quit" }))
map("n", "<leader>Q", "<cmd>qa!<cr>", vim.tbl_extend("force", opts, { desc = "Quit all (force)" }))

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", vim.tbl_extend("force", opts, { desc = "Clear search highlight" }))

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<cr>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection down" }))
map("v", "K", ":m '<-2<cr>gv=gv", vim.tbl_extend("force", opts, { desc = "Move selection up" }))

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Go to left window" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Go to lower window" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Go to upper window" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Go to right window" }))
map("n", "<leader>|", "<cmd>vsplit<cr>", vim.tbl_extend("force", opts, { desc = "Vertical split" }))
map("n", "<leader>-", "<cmd>split<cr>", vim.tbl_extend("force", opts, { desc = "Horizontal split" }))

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", opts)
map("n", "<C-Down>", "<cmd>resize -2<cr>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", vim.tbl_extend("force", opts, { desc = "Prev buffer" }))
map("n", "<S-l>", "<cmd>bnext<cr>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<leader>bd", "<cmd>bdelete<cr>", vim.tbl_extend("force", opts, { desc = "Delete buffer" }))
map("n", "<leader>bn", "<cmd>bnext<cr>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
map("n", "<leader>bp", "<cmd>bprevious<cr>", vim.tbl_extend("force", opts, { desc = "Prev buffer" }))

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", vim.tbl_extend("force", opts, { desc = "Toggle file explorer" }))
map("n", "<leader>n", "<cmd>NvimTreeToggle<cr>", vim.tbl_extend("force", opts, { desc = "Toggle file explorer" }))

-- Telescope (fuzzy finder) — plugin loads lazily, maps are safe (call only on use)
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Grep text" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
map("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Recent files" })
map("n", "<leader>fc", function() require("telescope.builtin").commands() end, { desc = "Commands" })
map("n", "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, { desc = "Document symbols" })
map("n", "<C-p>", function() require("telescope.builtin").find_files() end, { desc = "Find files" })

-- LSP (work once a language server attaches)
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", function() require("telescope.builtin").lsp_references() end, { desc = "Go to references" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })
map("n", "<leader>uf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  print("Format on save: " .. (vim.g.format_on_save and "ON" or "OFF"))
end, { desc = "Toggle format on save" })

-- Git (gitsigns)
map("n", "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Git blame line" })
map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview git hunk" })
map("n", "]h", function() require("gitsigns").next_hunk() end, { desc = "Next hunk" })
map("n", "[h", function() require("gitsigns").prev_hunk() end, { desc = "Prev hunk" })

-- Toggle terminal at the bottom (<leader>t opens/closes, same buffer kept)
local term_buf, term_win = nil, nil
local function toggle_term()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, false)
    term_win = nil
    return
  end
  if not (term_buf and vim.api.nvim_buf_is_valid(term_buf)) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end
  vim.cmd("botright 15split")
  term_win = vim.api.nvim_get_current_win()
  vim.wo[term_win].winfixheight = true
  vim.api.nvim_win_set_buf(term_win, term_buf)
  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.fn.termopen(vim.o.shell)
  end
  vim.cmd("startinsert")
end
map("n", "<leader>t", toggle_term, vim.tbl_extend("force", opts, { desc = "Toggle terminal (bottom)" }))
map("t", "<leader>t", function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, false)
    term_win = nil
  end
end, vim.tbl_extend("force", opts, { desc = "Close terminal" }))
map("t", "<Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Terminal: back to normal mode" }))

-- Comment toggle handled by Comment.nvim (gcc / gbc in normal, gc in visual)
-- Autocomplete handled by nvim-cmp: <C-Space> trigger, <CR> confirm, <Tab>/<S-Tab> navigate, <C-e> abort
