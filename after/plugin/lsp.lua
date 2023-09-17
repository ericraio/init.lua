local lsp = require("lsp-zero")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp = require('cmp')
local lspconfig = require('lspconfig')
local cmp_action = lsp.cmp_action()
local cmp_format = lsp.cmp_format()
local cms_select_opts = {behavior = cmp.SelectBehavior.Select}

local cmp_mappings = {
	['<CR>'] = cmp.mapping.confirm({select = false}),
	['<C-k>'] = cmp.mapping.select_prev_item(cmp_select_opts),
	['<C-j>'] = cmp.mapping.select_next_item(cmp_select_opts),
	['<C-u>'] = cmp.mapping.scroll_docs(4),
	['<C-d>'] = cmp.mapping.scroll_docs(-4),
	['<Tab>'] = cmp_action.luasnip_supertab(),
	['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
}

lsp.on_attach(function(client, bufnr)
	local opts = {buffer  = bufnr, remap = false}
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

mason.setup({})

mason_lspconfig.setup({
	ensure_installed = {
		'tsserver',
		'rust_analyzer',
		'yamlfmt'
	},
	handlers = {
		lsp.default_setup,
		lua_ls = function()
			local lua_opts = lsp.nvim_lua_ls()
			lspconfig.lua_ls.setup(lua_opts)
		end,
	}
})

cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
	},
	formatting = cmp_format,
	mapping = cmp_mappings
})

vim.diagnostic.config({
	virtual_text = true
})

-- function CheckBackSpace()
--   local col = vim.fn.col('.') - 1
--   return not col or vim.fn.getline('.')[col - 1] == ' '
-- end
