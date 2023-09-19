return {
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle },
    },
  },
}
