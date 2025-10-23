return {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    init = function()
        vim.g.everforest_background = 'soft'
        vim.g.everforest_better_performance = 1
        vim.g.everforest_diagnostic_text_highlight = 1
    end,
    config = function()
        vim.cmd [[ colorscheme everforest ]]
    end
}
