return {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.1',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" }
    },
    config = function()
        local builtin = require('telescope.builtin')
        local telescope = require('telescope')

        -- Load the live_grep_args extension
        telescope.load_extension('live_grep_args')

        -- Setup keymaps
        vim.keymap.set('n', '<leader>ff',
            ":lua require('telescope.builtin').find_files{ path_display = { shorten = { len = 2, exclude = {-1} } } }<CR>",
            {})
        vim.keymap.set('n', '<leader>fg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
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
