vim.keymap.set("n", "<C-g>s", vim.cmd.Git);
vim.keymap.set("n", "<C-g>c", function() vim.cmd.Git("commit") end)
vim.keymap.set("n", "<C-g>p", function() vim.cmd.Git("push") end)


local gitBlameOpen = false

vim.keymap.set("n", "<C-g>b", function()
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
end)
