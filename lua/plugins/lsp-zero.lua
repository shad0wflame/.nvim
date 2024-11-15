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
        }
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'eslint',
          'rust_analyzer',
          'vtsls'
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
          ts_ls = function()
            local util = require('lspconfig/util')
            require('lspconfig').ts_ls.setup({
              auto_start = true,
              single_file_support = true,
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
          pyright = function()
            local util = require('lspconfig/util')
            local path = util.path

            local function get_python_path(--[[workspace--]])
              -- To use Django install this:
              -- pip install django-stubs

              -- Use activated virtualenv.
              if vim.env.VIRTUAL_ENV then
                return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
              end

              --[[ Find and use virtualenv in workspace directory.
              for _, pattern in ipairs({'*', '.*'}) do
                local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
                if match ~= '' then
                  return path.join(path.dirname(match), 'bin', 'python')
                end
              end--]]

              -- Fallback to system Python.
              return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
            end

            require('lspconfig').pyright.setup({
              on_init = function(client)
                client.config.settings.python.pythonPath = get_python_path()
              end,
              capabilities = capabilities
            })
          end,
          pylsp = function()
            local util = require('lspconfig/util')
            local path = util.path

            local function get_python_path(--[[workspace--]])
              -- Use activated virtualenv.
              if vim.env.VIRTUAL_ENV then
                return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
              end

              --[[ Find and use virtualenv in workspace directory.
              for _, pattern in ipairs({'*', '.*'}) do
                local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
                if match ~= '' then
                  return path.join(path.dirname(match), 'bin', 'python')
                end
              end--]]

              -- Fallback to system Python.
              return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
            end

            require('lspconfig').pylsp.setup({
              settings = {
                plugins = {
                  -- Virtual envs
                  jedi = {
                    auto_import_modules = {"app"},
                    environment = get_python_path(),
                  },
                  jedi_completion = {
                    enabled = true,
                    fuzzy = true,
                  },
                  -- Lint
                  ruff = {
                    enabled = true,
                    select = {
                      -- enable pycodestyle
                      "E",
                      -- enable pyflakes
                      "F",
                    },
                    ignore = {
                      -- ignore E501 (line too long)
                      -- "E501",
                      -- ignore F401 (imported but unused)
                      -- "F401",
                    },
                    extendSelect = { "I" },
                    severities = {
                      -- Hint, Information, Warning, Error
                      F401 = "I",
                      E501 = "I",
                    },
                  },
                  flake8 = { enabled = false },
                  pyflakes = { enabled = false },
                  pycodestyle = { enabled = false },
                  mccabe = { enabled = false },

                  -- Code refactor
                  rope = { enabled = true },

                  -- Code autocompletion
                  rope_autoimport = {
                    enabled = true,
                  },
                  rope_completion = {
                    enabled = true,
                  },

                  -- Formatting
                  black = { enabled = true },
                  pyls_isort = { enabled = false },
                  autopep8 = { enabled = false },
                  yapf = { enabled = false },
                },
              },
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
