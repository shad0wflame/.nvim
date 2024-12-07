return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = false },
        bufdelete = { enabled = true },
        dashboard = { enable = true },
        debug = { enable = false },
        git = { enable = false },
        gitbrowse = { enable = false },
        lazygit = { enable = false },
        nofify = { enable = false },
        notifier = { enabled = false },
        profiler = { enabled = false },
        quickfile = { enabled = false },
        rename = { enabled = false },
        scratch = { enabled = false },
        statuscolumn = { enabled = false },
        terminal = { enabled = false },
        toggle = { enabled = false },
        win = { enabled = false },
        words = { enabled = false },
    },
    keys = {
        { "<leader>q", function() Snacks.bufdelete() end, desc = "Delete Buffer" }
    }
}
