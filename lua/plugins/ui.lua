return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      local logo = [[
        Eric Raio
        ]]
      opts.section.header.val = vim.split(logo, "\n", { trimempty = true })
    end,
  },
}
