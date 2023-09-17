vim.keymap.set("n", "<C-g>s", vim.cmd.Git);
vim.keymap.set("n", "<C-g>c", function() vim.cmd.Git("commit") end)
