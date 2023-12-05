return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.1',
	dependencies = {
		'nvim-lua/plenary.nvim'
	},
  config = function ()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set("n", '<leader>fs', function()
      vim.ui.input({ prompt = "Workspace symbols: " }, function(query)
        builtin.lsp_workspace_symbols({ query = query })
      end)
    end, { desc = "LSP workspace symbols" })
    vim.keymap.set("n", '<leader>fds', builtin.lsp_document_symbols, {})
  end
}

