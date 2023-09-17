local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Magic buffer-picking mode
map('n', '<C-w>', '<Cmd>BufferPick<CR>', opts)
-- Goto buffer in position...
map('n', '<C-w>1', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<C-w>2', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<C-w>3', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<C-w>4', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<C-w>5', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<C-w>6', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<C-w>7', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<C-w>8', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<C-w>9', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<C-w>0', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<C-w>p', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<C-w>c', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Sort automatically by...
map('n', '<C-w>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<C-3>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<C-3>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<C-3>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- function CheckBackSpace()
--   local col = vim.fn.col('.') - 1
--   return not col or vim.fn.getline('.')[col - 1] == ' '
-- end
