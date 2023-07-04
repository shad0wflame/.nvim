vim.g.loaded_netrw = 1
vim.g.loaded_netwrPlugin = 1

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.termguicolors = true

vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.opt.colorcolumn = "80"
vim.opt.updatetime = 300

vim.opt.clipboard = 'unnamedplus'
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- <space> as leader
vim.g.mapleader = " "

-- setup Lazy.nvim (:Lazy)
require("lazy").setup('plugins')

-- setup keymap
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "<leader>ww", ":wa<CR>")
vim.keymap.set("n", "<leader>qq", ":quitall!<CR>")
vim.keymap.set("n", "<leader>qf", ":q<CR>")

vim.keymap.set("n", "<leader>hs", "<C-w>s", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>vs", "<C-w>v", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cr", ':lua vim.lsp.buf.rename()<CR>')
vim.keymap.set("n", "<leader>ca", ':lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set("n", "<leader>tt", ':TroubleToggle<CR>', { silent = true })
vim.keymap.set("n", "<C-space>", ':lua vim.lsp.buf.hover()<CR>', { silent = true })

-- setup theme
vim.g.everforest_background = 'soft'
vim.g.everforest_better_performance = 1
vim.g.everforest_diagnostic_text_highlight = 1
vim.cmd [[ colorscheme everforest ]]

-- plugins setup
require('lualine').setup({
  options = {
    theme = 'everforest',
    disabled_filetypes = {
      'NvimTree'
    },
  }
})

require("bufferline").setup({
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "Nvim Tree",
        separator = true
      }
    },
  }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { 
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "rust",
    "javascript",
    "typescript",
    "html",
    "css",
    "scss"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- Folding options
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldcolumn = "3"

require("nvim-tree").setup({
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  }
})
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>1", ":NvimTreeFocus<CR>", { silent = true })

require('neoscroll').setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = true,    -- Disable "Performance Mode" on all buffers.
})

require('gitsigns').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

lspconfig.cssls.setup({
  capabilities = capabilities
})

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  capabilities = capabilities
})

--[[
lspconfig.tsserver.setup({
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
  capabilities = capabilities
})
]]--

-- this is for diagnositcs signs on the line number column
-- use this to beautify the plain E W signs to more fun ones
-- !important nerdfonts needs to be setup for this to work in your terminal
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
    }
)

local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<leader>sb", ":DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>sd", ":DapContinue<CR>")

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath('data') .. '/mason/bin/codelldb' ,
    args = {"--port", "${port}"},
  }
}

dap.configurations.rust = {
  {
    name = "Rust debug",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}

require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

require("lsp_lines").setup()
