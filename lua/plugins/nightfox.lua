return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        --[[
        require("nightfox").setup({
            groups = {
                all = {
                    DiagnosticUnderlineError = { bg = "#4b2a3d" },
                },
            },
        })
        --]]
        -- vim.cmd([[ colorscheme nordfox ]])
    end,

}
