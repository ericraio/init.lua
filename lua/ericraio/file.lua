-- Set the current file as an executable
vim.keymap.set("n", "<C-f>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Remove the current file as an exectuable
vim.keymap.set("n", "<C-f>ux", "<cmd>!chmod -x %<CR>", { silent = true })
