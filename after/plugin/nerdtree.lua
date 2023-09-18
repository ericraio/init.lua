-- Activate the NERDTree and navigate to the directory in which the new file
-- should live. 
-- Then press m to bring up the NERDTree Filesystem Menu and choose a 
-- for "add child node". 
-- Then simply enter the file's (or directory's name) and you're done.

local open = false

-- Toggle NERDTree with refresh
function ToggleNERDTreeWithRefresh()
    if open then
        open = false
        vim.cmd("NERDTreeClose")
    else
        open = true
        vim.cmd("NERDTreeToggle")
        vim.cmd("call feedkeys('R')")
    end
end

-- Map ctrl-r to ToggleNERDTreeWithRefresh()
vim.keymap.set('n', '<C-t>', ToggleNERDTreeWithRefresh, {noremap = true})
vim.keymap.set('n', '<leader>n', ToggleNERDTreeWithRefresh, {noremap = true})
