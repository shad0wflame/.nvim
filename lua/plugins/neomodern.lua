return {
    "cdmill/neomodern.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("neomodern").setup()
        require("neomodern").load()
        vim.cmd [[ colorscheme iceclimber ]]
    end
}
