-- local lsp = require("lsp-zero").preset({})
-- local mason = require("mason")
-- local mason_lspconfig = require("mason-lspconfig")
-- local cmp = require('cmp')
-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
-- local lspconfig = require('lspconfig')
-- local configs = require('lspconfig.configs')
-- local cmp_action = lsp.cmp_action()
-- local cmp_format = lsp.cmp_format()
-- local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
--
-- local cmp_mappings = {
--     ['<CR>'] = cmp.mapping.confirm({ select = false }),
--     ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select_opts),
--     ['<C-j>'] = cmp.mapping.select_next_item(cmp_select_opts),
--     ['<C-u>'] = cmp.mapping.scroll_docs(4),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<Tab>'] = cmp_action.luasnip_supertab(),
--     ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
-- }
--
-- -- nvim-cmp supports additional completion capabilities
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- capabilities.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true,
-- }
--
-- -- -------------------- general settings -- --------------------
-- vim.fn.sign_define('DiagnosticSignError', {
--     texthl = 'DiagnosticSignError',
--     text = ' ✗',
--     numhl = 'DiagnosticSignError',
-- })
-- vim.fn.sign_define('DiagnosticSignWarn', {
--     texthl = 'DiagnosticSignWarn',
--     text = ' ❢',
--     numhl = 'DiagnosticSignWarn',
-- })
-- vim.fn.sign_define('DiagnosticSignHint', {
--     texthl = 'DiagnosticSignHint',
--     text = ' ',
--     numhl = 'DiagnosticSignHint',
-- })
-- vim.fn.sign_define('DiagnosticSignInfo', {
--     texthl = 'DiagnosticSignInfo',
--     text = ' 𝓲',
--     numhl = 'DiagnosticSignInfo',
-- })
--
-- vim.diagnostic.config({
--     signs = true,
--     update_in_insert = false,
--     underline = true,
--     severity_sort = true,
--     virtual_text = true,
-- })
--
-- -- -------------------------- common lsp server ----------------------
-- local servers = {
--     'bashls',
--     'sqlls',
--     'clangd',
--     'texlab',
--     'dockerls',
--     'marksman',
-- }
--
-- for _, srv in ipairs(servers) do
--     lspconfig[srv].setup({
--         on_attach = on_attach,
--         capabilities = capabilities,
--         root_dir = function()
--             return vim.fn.getcwd()
--         end,
--     })
-- end
--
--
-- mason.setup({})
--
-- mason_lspconfig.setup({
--     ensure_installed = {
--         'html', 'jsonls', 'bashls'
--     },
--     handlers = {
--         lsp.default_setup,
--         lua_ls = function()
--             local lua_opts = lsp.nvim_lua_ls()
--             lspconfig.lua_ls.setup(lua_opts)
--         end,
--     }
-- })
--
-- cmp.setup({
--     sources = {
--         { name = 'nvim_lsp' }
--     },
--     formatting = cmp_format,
--     mapping = cmp_mappings
-- })
--
-- if not configs.sourcekit_lsp then
--     configs.sourcekit_lsp = {
--         default_config = {
--             name = 'sourcekit_lsp',
--             cmd = { '/usr/bin/xcrun', 'sourcekit-lsp' },
--             filetypes = { 'swift', 'cpp', 'objective-c', 'objective-cpp' },
--             root_dir = function(fname)
--                 local package_dir = util.root_pattern('Package.swift')(fname)
--                 if package_dir then
--                     return package_dir
--                 end
--
--                 return vim.fn.getcwd()
--             end
--         }
--     }
-- end
--
-- lspconfig.sourcekit_lsp.setup({
--     on_attach = on_attach,
--     capabilities = capabilities
-- })
--
-- if not configs.vimls then
--     configs.vimls = {
--         default_config = {
--             name = 'vimls',
--             cmd = { 'vim-language-server' },
--             filetypes = { 'vim' },
--             root_dir = function(_) -- var fname
--                 return vim.fn.getcwd()
--             end
--         }
--     }
-- end
-- lspconfig.vimls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities
-- })
--
-- -- https://github.com/nicknisi/dotfiles/blob/6ab0b1d8d7fe888f6ba9bcc5cc1f98dfb435d246/config/nvim/lua/plugins/lsp/config.lua#L41
-- local function make_conf(...)
--   local cap = vim.lsp.protocol.make_client_capabilities()
--   cap.textDocument.foldingRange = {
--     dynamicRegistration = false,
--     lineFoldingOnly = true,
--   }
--   cap.textDocument.completion.completionItem.snippetSupport = true
--   cap.textDocument.completion.completionItem.resolveSupport = {
--     properties = { "documentation", "detail", "additionalTextEdits", "documentHighlight" },
--   }
--   cap.textDocument.colorProvider = { dynamicRegistration = false }
--   cap= cmp_nvim_lsp.default_capabilities(cap)
--
--   return vim.tbl_deep_extend("force", {
--     handlers = {
--       ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
--       ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
--       ["textDocument/formatting"] = format_async,
--       ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = true,
--       }),
--     },
--     capabilities = cap,
--   }, ...)
-- end

-- function CheckBackSpace()
--   local col = vim.fn.col('.') - 1
--   return not col or vim.fn.getline('.')[col - 1] == ' '
-- end
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
    { "folke/neodev.nvim", opts = {} },
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
      "hrsh7th/cmp-nvim-lsp",
      cond = function()
        return require("lazyvim.util").has("nvim-cmp")
      end,
    },
  },
  ---@class PluginLspOpts
  opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        -- prefix = "icons",
      },
      severity_sort = true,
    },
    -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    inlay_hints = {
      enabled = false,
    },
    -- add any global capabilities here
    capabilities = {},
    -- Automatically format on save
    autoformat = true,
    -- Enable this to show formatters used in a notification
    -- Useful for debugging formatter issues
    format_notify = false,
    -- options for vim.lsp.buf.format
    -- `bufnr` and `filter` is handled by the LazyVim formatter,
    -- but can be also overridden when specified
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    -- LSP Server Settings
    ---@type lspconfig.options
    servers = {
      jsonls = {},
      lua_ls = {
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        -- Use this to add any additional keymaps
        -- for specific lsp servers
        ---@type LazyKeys[]
        -- keys = {},
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },
  ---@param opts PluginLspOpts
  config = function(_, opts)
    local Util = require("lazyvim.util")

    if Util.has("neoconf.nvim") then
      local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
    end
    -- setup autoformat
    require("lazyvim.plugins.lsp.format").setup(opts)
    -- setup formatting and keymaps
    Util.on_attach(function(client, buffer)
      require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
    end)

    local register = "client/registerCapability"
    local register_capability = vim.lsp.handlers[register]
    vim.lsp.handlers[register] = function(err, res, ctx)
      local ret = register_capability(err, res, ctx)
      local client_id = ctx.client_id
      local client = vim.lsp.get_client_by_id(client_id)
      local buffer = vim.api.nvim_get_current_buf()
      require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      return ret
    end

    -- diagnostics
    for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
      name = "DiagnosticSign" .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")
    local util = require("lspconfig.util")
    if not configs.sourcekit_lsp then
      configs.sourcekit_lsp = {
        default_config = {
          name = "sourcekit_lsp",
          cmd = { "/usr/bin/xcrun", "sourcekit-lsp" },
          filetypes = { "swift", "cpp", "objective-c", "objective-cpp" },
          root_dir = function(fname)
            local package_dir = util.root_pattern("Package.swift")(fname)
            if package_dir then
              return package_dir
            end

            return vim.fn.getcwd()
          end,
        },
      }
    end
    lspconfig.sourcekit_lsp.setup({})
    if not configs.vimls then
      configs.vimls = {
        default_config = {
          name = "vimls",
          cmd = { "vim-language-server" },
          filetypes = { "vim" },
          root_dir = function(_) -- var fname
            return vim.fn.getcwd()
          end,
        },
      }
    end
    lspconfig.vimls.setup({})

    local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

    if opts.inlay_hints.enabled and inlay_hint then
      Util.on_attach(function(client, buffer)
        if client.supports_method("textDocument/inlayHint") then
          inlay_hint(buffer, true)
        end
      end)
    end

    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
        or function(diagnostic)
          local icons = require("lazyvim.config").icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
    end

    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    local servers = opts.servers
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      opts.capabilities or {}
    )

    local function setup(server)
      local server_opts = vim.tbl_deep_extend("force", {
        capabilities = vim.deepcopy(capabilities),
      }, servers[server] or {})

      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end

    -- get all the servers that are available through mason-lspconfig
    local have_mason, mlsp = pcall(require, "mason-lspconfig")
    local all_mslp_servers = {}
    if have_mason then
      all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
    end

    local ensure_installed = {} ---@type string[]
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    if have_mason then
      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end
  end,
}
