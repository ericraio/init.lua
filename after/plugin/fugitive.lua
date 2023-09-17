vim.keymap.set("n", "<C-g>c", function() vim.cmd.Git("commit") end)
vim.keymap.set("n", "<C-g>p", function() vim.cmd.Git("push") end)

local gitDiffOpen = false
vim.keymap.set("n", "<C-g>d", function()
    if gitDiffOpen then
        local name = vim.api.nvim_buf_get_name(0)
        if string.find(name, ".git") then
            gitDiffOpen = false
            vim.cmd("bd " .. name)
        end
    else
        gitDiffOpen = true
        vim.cmd.Gdiff()
    end
end);


local gitStatusOpen = false
vim.keymap.set("n", "<C-g>s", function()
    if gitStatusOpen then
        local name = vim.api.nvim_buf_get_name(0)
        if string.find(name, "") then
            gitStatusOpen = false
            vim.cmd("bd " .. name)
        end
    else
        gitStatusOpen = true
        vim.cmd.Git()
    end
end);


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
