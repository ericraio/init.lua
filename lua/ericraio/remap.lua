local opts = {
    noremap = true
}

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

----- hides the search highlight
vim.keymap.set("n", "<leader>hs", vim.cmd.nohlsearch)

----- copy pasta

-- replaces the current word but when pasting,
-- it's not using the replaced word
vim.keymap.set("x", "P", "\"_dP")

vim.keymap.set("n", "<M-c>", "\"+y")
vim.keymap.set("v", "<M-c>", "\"+y")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-----------------
-- Remove Keys --
-----------------

vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")

vim.keymap.set("n", "<C-y>", function()
    vim.lsp.buf.format()
end)

-----------------
--   Movement  --
-----------------

vim.keymap.set("n", "<C-k>", "<CMD>silent! move-2<CR>==")
vim.keymap.set("n", "<C-j>", "<CMD>silent! move+<CR>==")
vim.keymap.set("x", "<C-k>", "<CMD>silent! '<,'>move-2<CR>gv=gv")
vim.keymap.set("x", "<C-j>", "<CMD>silent! '<,'>move'>+<CR>gv=gv")

-----------------
-- Normal mode --
-----------------

-- 
vim.keymap.set("n", "<leader>f", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- keep the cursor in the middle
vim.keymap.set("n", "<C-d", "<C-d>zz")
vim.keymap.set("n", "<C-u", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- Hint: see `:h vim.map.set()`
-- Better window navigation
vim.api.nvim_set_keymap('n', '<C-w>k', ':wincmd k<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-w>j', ':wincmd j<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-w>h', ':wincmd h<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-w>l', ':wincmd l<CR>', {noremap = true})

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-----------------
--   Ex mode   --
-----------------
