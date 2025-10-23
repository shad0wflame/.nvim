return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        --[[
        require("tokyonight").setup({
            style = "storm",
            on_highlights = function(hl, c)
                hl.DiagnosticUnderlineError = { bg = "#4b2a3d", undercurl = true }
            end,
        })
        vim.cmd [[ colorscheme tokyonight-moon ]]
        --]]
    end
}
