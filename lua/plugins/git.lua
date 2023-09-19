local gitDiffOpen = false
local gitStatusOpen = false
local gitBlameOpen = false

return {
  "tpope/vim-fugitive",
  keys = {
    {
      "<C-g>c",
      function()
        vim.cmd.Git("commit")
      end,
    },
    {
      "<C-g>p",
      function()
        vim.cmd.Git("push")
      end,
    },
    {
      "<C-g>pu",
      function()
        vim.cmd.Git("pull")
      end,
    },
    {
      "<C-g>d",
      function()
        if gitDiffOpen then
          gitDiffOpen = false
          local name = vim.api.nvim_buf_get_name(0)
          if string.find(name, ".git") then
            vim.cmd("bd " .. name)
          end
        else
          gitDiffOpen = true
          vim.cmd.Gdiff()
        end
      end,
    },
    {
      "<C-g>b",
      function()
        if gitBlameOpen then
          local name = vim.api.nvim_buf_get_name(0)
          if string.find(name, "fugitiveblame") then
            gitBlameOpen = false
            vim.cmd("q")
          end
        else
          gitBlameOpen = true
          vim.cmd.Git("blame")
        end
      end,
    },
    {
      "<C-g>s",
      function()
        if gitStatusOpen then
          gitStatusOpen = false
          local name = vim.api.nvim_buf_get_name(0)
          if string.find(name, "") then
            vim.cmd("bd " .. name)
          end
        else
          gitStatusOpen = true
          vim.cmd.Git()
        end
      end,
    },
  },
}
