return {
  -- add telescope-fzf-native
  {
    "telescope.nvim",
    keys = {},
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = {
            ".git",
            "log",
            "tmp",
            "**/public/assets",
            "**/public/packs",
            "**/public/packs-test",
            "build",
            "./priv",
            "vendor",
            "**/node_modules",
            "**/deps",
            "coverage",
          },
        },
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<c-t>"] = require("telescope.actions").select_tab,
            },
            n = {
              ["<c-t>"] = require("telescope.actions").select_tab,
            },
          },
        },
      })
    end,
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      { "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "Resume" } },
    },
  },
}
