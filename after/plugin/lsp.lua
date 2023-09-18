local lsp = require("lsp-zero").preset({})
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp = require('cmp')
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local cmp_action = lsp.cmp_action()
local cmp_format = lsp.cmp_format()
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select_opts),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select_opts),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
}


-- https://github.com/AGou-ops/dotfiles/blob/76a32f9af8555e00d71c5b86a5a5912563d393d6/neovim/lua/plugins/lsp/init.lua#L125
local on_attach = function(_, bufnr)
    -- require("lsp-format").on_attach(client)
    -- require("nvim-navic").attach(client, bufnr)

    -- enable inlay hint
    vim.lsp.buf.inlay_hint(0, true)

    -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    local map = vim.api.nvim_buf_set_keymap
    -- map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- use lspsaga.goto_definition instead.
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- map(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    map(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    map(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    map(
        bufnr,
        'n',
        '<leader>wl',
        '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
        opts
    )
    map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- map(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    map(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    map(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    map(
        bufnr,
        'n',
        '<leader>so',
        [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
        opts
    )
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
    -- goto preview keymappings
    map(
        bufnr,
        'n',
        'gp',
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        opts
    )
    map(
        bufnr,
        'n',
        'gpi',
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        opts
    )
    map(bufnr, 'n', 'gpt',
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        opts
    )
    map(bufnr, 'n', 'gq', "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)
    map(
        bufnr,
        'n',
        'gF',
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        opts
    )
end
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

-- -------------------- general settings -- --------------------
vim.fn.sign_define('DiagnosticSignError', {
    texthl = 'DiagnosticSignError',
    text = ' ✗',
    numhl = 'DiagnosticSignError',
})
vim.fn.sign_define('DiagnosticSignWarn', {
    texthl = 'DiagnosticSignWarn',
    text = ' ❢',
    numhl = 'DiagnosticSignWarn',
})
vim.fn.sign_define('DiagnosticSignHint', {
    texthl = 'DiagnosticSignHint',
    text = ' ',
    numhl = 'DiagnosticSignHint',
})
vim.fn.sign_define('DiagnosticSignInfo', {
    texthl = 'DiagnosticSignInfo',
    text = ' 𝓲',
    numhl = 'DiagnosticSignInfo',
})

vim.diagnostic.config({
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = true,
})

-- -------------------------- common lsp server ----------------------
local servers = {
    'bashls',
    'sqlls',
    'clangd',
    'texlab',
    'dockerls',
    'marksman',
}

for _, srv in ipairs(servers) do
    lspconfig[srv].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = function()
            return vim.fn.getcwd()
        end,
    })
end


mason.setup({})

mason_lspconfig.setup({
    ensure_installed = {
        'html', 'jsonls', 'bashls'
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
        { name = 'nvim_lsp' }
    },
    formatting = cmp_format,
    mapping = cmp_mappings
})

if not configs.sourcekit_lsp then
    configs.sourcekit_lsp = {
        default_config = {
            name = 'sourcekit_lsp',
            cmd = { '/usr/bin/xcrun', 'sourcekit-lsp' },
            filetypes = { 'swift', 'cpp', 'objective-c', 'objective-cpp' },
            root_dir = function(fname)
                local package_dir = util.root_pattern('Package.swift')(fname)
                if package_dir then
                    return package_dir
                end

                return vim.fn.getcwd()
            end
        }
    }
end

lspconfig.sourcekit_lsp.setup({
    on_attach = on_attach,
    capabilities = capabilities
})

if not configs.vimls then
    configs.vimls = {
        default_config = {
            name = 'vimls',
            cmd = { 'vim-language-server' },
            filetypes = { 'vim' },
            root_dir = function(_) -- var fname
                return vim.fn.getcwd()
            end
        }
    }
end
lspconfig.vimls.setup({
    on_attach = on_attach,
    capabilities = capabilities
})

-- https://github.com/nicknisi/dotfiles/blob/6ab0b1d8d7fe888f6ba9bcc5cc1f98dfb435d246/config/nvim/lua/plugins/lsp/config.lua#L41
local function make_conf(...)
  local cap = vim.lsp.protocol.make_client_capabilities()
  cap.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  cap.textDocument.completion.completionItem.snippetSupport = true
  cap.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits", "documentHighlight" },
  }
  cap.textDocument.colorProvider = { dynamicRegistration = false }
  cap= cmp_nvim_lsp.default_capabilities(cap)

  return vim.tbl_deep_extend("force", {
    handlers = {
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
      ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      ["textDocument/formatting"] = format_async,
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
      }),
    },
    capabilities = cap,
  }, ...)
end

-- function CheckBackSpace()
--   local col = vim.fn.col('.') - 1
--   return not col or vim.fn.getline('.')[col - 1] == ' '
-- end
