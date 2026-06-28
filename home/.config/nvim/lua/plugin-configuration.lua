local pick_colorscheme = require("custom-functionality/colorscheme-picker")

require("lazy").setup({
  ----- Helper Libraries ------------------------------------------------------
  "nvim-lua/plenary.nvim",

  ----- Color Schemes ---------------------------------------------------------
  ----- Convenience: comment out everything that isn't being used. 

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   config = function() vim.cmd("colorscheme tokyonight") end
  -- },
  {
    "neanias/everforest-nvim",
    lazy = false,
    -- config = function() vim.cmd("colorscheme everforest") end
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    config = function() vim.cmd("colorscheme github_dark") end
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   config = function() vim.cmd("colorscheme catppuccin-macchiato") end
  -- },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    -- config = function() vim.cmd("colorscheme gruvbox-material") end
  },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function() vim.cmd("colorscheme rose-pine") end
  -- },
  -- {
  --   "daltonmenezes/aura-theme",
  --   lazy = false,
  --   config = function() vim.cmd("colorscheme aura-theme") end
  -- },
  {
    "xero/miasma.nvim",
    lazy = false,
    -- config = function() vim.cmd("colorscheme miasma") end,
  },

  ----- nvim-tree.lua ---------------------------------------------------------
  ----- IDE-style file explorer.
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom splits
        vim.keymap.set('n', 's', api.node.open.vertical, {
          buffer = bufnr,
          noremap = true,
          silent = true,
          desc = "Open in vertical split"
        })
        vim.keymap.set('n', 'S', api.node.open.horizontal, {
          buffer = bufnr,
          noremap = true,
          silent = true,
          desc = "Open in horizontal split"
        })
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach,
        view = {
          width = 30,
          side = "left",
        },
      })

      -- global toggle
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
        silent = true,
        desc = " Toggle Explorer",
      })
    end
  },

  ----- telescope.nvim --------------------------------------------------------
  ----- Improved search and display container.
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "󰈞 Find Files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "󰊄 Live Grep" })
    end,
    opts = {
      pickers = {
        colorscheme = {
          enable_preview = true,
        }
      }
    }
  },

  ----- nvim-treesitter -------------------------------------------------------
  ----- The one and only plugin that actually matters.
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  },

  ----- nvim-lspconfig --------------------------------------------------------
  ----- LSP management.
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Lua
      vim.lsp.config("lua_ls", { capabilities = capabilities })
      vim.lsp.enable("lua_ls")
      -- Python
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.enable("pyright")
      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.enable("ts_ls")
      -- Rust
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })
      vim.lsp.enable("rust_analyzer")
    end
  },

  ----- which-key -------------------------------------------------------------
  ----- Indispensable hotkey visual helper.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")

      wk.setup({
        preset = "helix", -- cleaner display
        icons = {
          rules = false,
        },
      })

      wk.add({
        -- Basic --
        { "<leader>q", ":q<CR>", desc = "󰗼 Quit" },
        { "<leader>w", ":w<CR>", desc = "󰝒 Save" },

        -- Misc --
        { "<leader>c", ":nohlsearch<CR>", desc = "󰅖 Clear Search Highlight" },

        -- Buffers --
        { "<leader>b", group = "󰓩 Buffers" },
        { "<leader>bb", "<cmd>Telescope buffers<CR>", desc = "󰸩 List Buffers" },
        { "<leader>bd", ":bd<CR>", desc = "󰗼 Delete Buffer" },
        { "<leader>bn", ":bnext<CR>", desc = "󰒭 Next Buffer" },
        { "<leader>bp", ":bprevious<CR>", desc = "󰒮 Previous Buffer" },

        -- Find --
        { "<leader>f", group = "󰍉 Find" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "󰞋 Help" },
        { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "󰋚 Recent Files" },

        -- UI --
        { "<leader>u", group = "󰙵 UI" },
        { "<leader>uc", pick_colorscheme, desc = " Colorscheme (Live)" },
        { "<leader>ub", function() vim.o.background = vim.o.background == 'dark' and 'light' or 'dark' end, desc = "󱠡 Toggle Background" },

        -- Terminal --
        { "<leader>t", group = " Terminal" },
        { "<leader>tt", "<cmd>TabTerm<CR>", desc = "󰆍 New Tab Terminal" },
        { "<leader>tv", "<cmd>VTerm<CR>", desc = " New Vertical Terminal" },
        { "<leader>tc", "<cmd>VTerm codex<CR>", desc = "󱜙 Vertical Codex Terminal" },

        -- Git --
        { "<leader>g", group = "󰊢 Git" },
        { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "󰊢 Status" },
        { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "󰜘 Commits" },
        { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = " Branches" },
        { "<leader>gG", "<cmd>Gitsigns toggle_signs<CR>", desc = "󰈞 Toggle" },
        { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "󰈞 Diff" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "󰐙 Preview Hunk" },
        { "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", desc = "󰒭 Next Hunk" },
        { "<leader>gN", "<cmd>Gitsigns prev_hunk<CR>", desc = "󰒮 Previous Hunk" },

        -- Minimap --
        { "<leader>m", group = "󰏖 Minimap" },

        -- Plugins --
        { "<leader>p", group = "󰏖 Plugins" },
        { "<leader>pp", ":Lazy<CR>", desc = "󰒲 Lazy" },
        { "<leader>pm", ":Mason<CR>", desc = "󰀘 Mason" },
        { "<leader>pl", ":Lazy sync<CR>", desc = "󰑪 Update Plugins" },

        -- LSP --
        { "<leader>l", group = "󰿘 LSP" },
        { "<leader>lf", function() vim.lsp.buf.format { async = true } end, desc = "󰉢 Format" },
        { "<leader>lr", vim.lsp.buf.rename, desc = "󰑕 Rename" },
        { "<leader>ld", vim.lsp.buf.definition, desc = "󰌹 Definition" },
        { "<leader>lD", vim.lsp.buf.declaration, desc = "󰌹 Declaration" },
        { "<leader>lt", vim.lsp.buf.type_definition, desc = " Type Definition" },
        { "<leader>li", vim.lsp.buf.implementation, desc = "󰡱 Implementation" },
        { "<leader>lh", vim.lsp.buf.hover, desc = "󰋗 Hover Docs" },
        { "<leader>ls", vim.lsp.buf.signature_help, desc = "󰊕 Signature Help" },
        { "<leader>la", vim.lsp.buf.code_action, desc = "󰌵 Code Action" },
        { "<leader>ln", vim.diagnostic.goto_next, desc = "󰒭 Next Diagnostic" },
        { "<leader>lp", vim.diagnostic.goto_prev, desc = "󰒮 Prev Diagnostic" },
        { "<leader>lo", "<cmd>Telescope lsp_document_symbols<CR>", desc = "󰈙 Document Symbols" },
        { "<leader>lO", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "󰈙 Workspace Symbols" },

        -- Run --
        { "<leader>r", group = "󰑮 Run" },
      })
    end,
    dependencies = {
      "nvim-mini/mini.icons",
      "nvim-tree/nvim-web-devicons",
    }
  },

  ----- mason.nvim ------------------------------------------------------------
  ----- External binary package management. Currently unused.
  {
    "lewis6991/gitsigns.nvim",
    opts = {}
  },

  ----- mason.nvim ------------------------------------------------------------
  ----- External binary package management. Currently unused.
  {
    "mason-org/mason.nvim",
    opts = {}
  },

  ----- lualine.nvim ----------------------------------------------------------
  ----- Beautiful status line plugin.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
            { "diagnostics", sources = { "nvim_diagnostic" } },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  ----- nvim-cmp --------------------------------------------------------------
  ----- This plugin completes me.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",      -- Buffer completions
      "hrsh7th/cmp-path",        -- File path completions
      "L3MON4D3/LuaSnip",        -- Snippet engine
      "saadparwaiz1/cmp_luasnip" -- Snippet completions
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  ----- whisk.nvim ------------------------------------------------------------
  ----- Animates all vim motions.
  {
    "josstei/whisk.nvim",
    config = function()
      require("whisk").setup({
        cursor = {
          duration = 100,
          easing = "ease-out",
          enabled = true,
        },
        scroll = {
          duration = 400,
          easing = "ease-out",
          enabled = true,
        },
        performance = { enabled = false },
        keymaps = {
          cursor = true,
          scroll = true,
        },
      })
    end,
  },

  ----- smear-cursor.nvim -----------------------------------------------------
  ----- Animates all movements.
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5
    },
  },

  ----- codewindow.nvim -------------------------------------------------------
  ----- Minimap plugin.
  {
    'gorbit99/codewindow.nvim',
    config = function()
      require('codewindow.config').setup({
        use_treesitter = false,
      })
      local codewindow = require('codewindow')
      codewindow.setup({
        use_treesitter = false,
      })
      codewindow.apply_default_keybinds()
    end,
  },
})
