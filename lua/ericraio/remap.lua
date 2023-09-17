vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

----- hides the search highlight
vim.keymap.set("n", "<leader>hs", vim.cmd.nohlsearch)

----- keep the cursor in the middle
vim.keymap.set("n", "<C-d", "<C-d>zz")
vim.keymap.set("n", "<C-u", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

----- copy pasta

-- replaces the current word but when pasting,
-- it's not using the replaced word
vim.keymap.set("x", "P", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

----- remove keys
vim.keymap.set("n", "Q", "<nop>")


vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)
