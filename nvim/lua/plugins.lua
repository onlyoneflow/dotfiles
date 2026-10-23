-- Plugins via lazy.nvim. Run :Lazy, :Mason to manage.
return {
  -- ===== Beauty =====
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night", transparent = true },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- Прозрачный lualine: сносим bg у всех секций темы, иначе будет "полоска" на всю ширину.
      -- Заодно тёмный fg (рассчитанный на цветную подложку) делаем белым, иначе не видно.
      local function luminance(hex)
        if type(hex) ~= "string" then return 255 end
        local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
        if not r then return 255 end
        r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
        return 0.299 * r + 0.587 * g + 0.114 * b
      end
      local theme = require("lualine.themes.tokyonight")
      for _, mode in pairs(theme) do
        for _, section in pairs(mode) do
          if type(section) == "table" then
            section.bg = "NONE"
            if section.fg and luminance(section.fg) < 55 then
              section.fg = "#ffffff"
            end
          end
        end
      end
      return {
        options = { theme = theme, globalstatus = true },
        sections = {
          lualine_c = { { "filename", path = 1 } }, -- relative path
        },
      }
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {},
  },

  -- ===== File explorer =====
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = { width = 32 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      actions = { open_file = { quit_on_open = true } },
    },
  },

  -- ===== Fuzzy finder =====
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Grep text" },
      { "<C-p>", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },

  -- ===== Syntax / highlighting =====
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- stable API (main branch has breaking changes)
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "python", "javascript", "typescript", "tsx", "json", "html", "css", "bash", "markdown" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- ===== LSP + smart autocomplete =====
  { "williamboman/mason.nvim", cmd = { "Mason", "MasonUpdate", "MasonInstall", "MasonUninstall", "MasonLog" }, opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "jsonls", "bashls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- New Neovim 0.11+ API (no deprecated require('lspconfig') framework)
      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        -- Lua: tell LS that `vim` is a global for Neovim config
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "jsonls", "bashls" })
    end,
  },

  -- Completion engine (the "smart auto suggestions")
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP suggestions
      "hrsh7th/cmp-buffer",       -- words in current file
      "hrsh7th/cmp-path",         -- file paths
      "hrsh7th/cmp-cmdline",      -- : commands
      "L3MON4D3/LuaSnip",         -- snippets
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),       -- trigger suggestions
          ["<C-e>"] = cmp.mapping.abort(),              -- dismiss
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Command-line completion: / search and : commands
      cmp.setup.cmdline("/", { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })
      cmp.setup.cmdline(":", { mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) })
    end,
  },

  -- ===== Editing helpers =====
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Toggle comment line" },
      { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    },
    opts = {},
  },

  -- ===== Git =====
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- ===== Key helper + todo highlights =====
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
