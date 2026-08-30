return {
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        mini = { enabled = true },
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = { enabled = true }
      opts.notifier = { enabled = true }
      opts.image = { enabled = true }
      opts.statuscolumn = { enabled = true }
      return opts
    end,
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
      if snacks.input and snacks.input.input then
        vim.ui.input = snacks.input.input
      end
      if snacks.picker and snacks.picker.select then
        vim.ui.select = snacks.picker.select
      end
      if snacks.notifier and snacks.notifier.notify then
        vim.notify = snacks.notifier.notify
      end
    end,
  },

  { "folke/which-key.nvim", opts = {} },

  { "tpope/vim-sleuth", event = "VeryLazy" },

  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },

  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>uT", "<cmd>UndotreeToggle<cr>", desc = "UndoTree Toggle" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Menu",
      },
      {
        "<leader>h1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon File 1",
      },
      {
        "<leader>h2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon File 2",
      },
      {
        "<leader>h3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon File 3",
      },
      {
        "<leader>h4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon File 4",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "css",
        "json",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scss",
        "svelte",
        "toml",
        "typst",
        "vue",
        "vim",
        "yaml",
      })
    end,
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>-",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at current file",
      },
    },
    opts = {
      open_for_directories = true,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
