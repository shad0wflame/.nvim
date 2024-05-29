return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    lazy = false,
    config = true,
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero.cmp').action()

      cmp.setup({
        formatting = lsp_zero.cmp_format({details = true}),
        mapping = {
          -- Enter key to confirm completion 
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          -- Ctrl + Space to trigger completion menu
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        }
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})
      end)

      lsp_zero.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 10000,
        },
        servers = {
          ['eslint'] = {'javascript', 'typescript', 'typescriptreact'},
          ['rust_analyzer'] = {'rust'},
        }
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'eslint',
          'tsserver',
          'rust_analyzer',
        },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
              capabilities = capabilities,
            })
          end,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
          tsserver = function()
            local util = require('lspconfig/util')
            require('lspconfig').tsserver.setup({
              auto_start = true,
              single_file_support = false,
              flags = {
                debounce_text_changes = 150
              },
              root_dir = function (pattern)
                local cwd  = vim.loop.cwd();
                local root = util.root_pattern("package.json", "tsconfig.json", ".git")(pattern);
                return root or cwd;
              end,
              capabilities = capabilities,
            })
          end,
          eslint = function()
            require('lspconfig').eslint.setup({
              on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  command = "EslintFixAll",
                })
              end,
              capabilities = capabilities
            })
          end,
        },
      })

      -- this is for diagnositcs signs on the line number column
      -- use this to beautify the plain E W signs to more fun ones
      -- !important nerdfonts needs to be setup for this to work in your terminal
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
      end

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
          {
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            underline = true,
          }
      )
    end
  }
}
