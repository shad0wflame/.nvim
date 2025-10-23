return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `toggle()`.
        { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
    },
    config = function()
        vim.g.opencode_opts = {
            -- Your configuration, if any — see `lua/opencode/config.lua`
            prompts = {
                -- With an "Ask" item, the select menu can serve as the only entrypoint to all plugin-exclusive functionality, without numerous keymaps.
                ask = { prompt = "", ask = true, submit = true },
                explain = { prompt = "Dame una explicacion de @this y de su contexto", submit = true },
                optimize = { prompt = "Optimiza @this para mejor rendimiento y legibilidad", submit = true },
                document = { prompt = "Añade comentarios documentando @this", submit = true },
                test = { prompt = "Añade tests para @this", submit = true },
                review = { prompt = "Revisa @this para mejorar su correccion y legibilidad", submit = true },
                diagnostics = { prompt = "Explicame @diagnostics", submit = true },
                fix = { prompt = "Arregla @diagnostics", submit = true },
                diff = { prompt = "Revisa el siguiente git diff para mejorar su correccion y legibilidad: @diff", submit = true },
                buffer = { prompt = "@buffer" },
                this = { prompt = "@this" },
            },
            on_send = nil,
            on_opencode_not_found = nil
        }

        -- Required for `vim.g.opencode_opts.auto_reload`
        vim.opt.autoread = true

        -- Recommended/example keymaps
        vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end,
            { desc = "Ask about this" })
        vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,
            { desc = "Select prompt" })
        vim.keymap.set({ "n", "x" }, "<leader>o+", function() require("opencode").prompt("@this") end,
            { desc = "Add this" })
        vim.keymap.set("n", "<leader>ot", function() require("opencode").toggle() end, { desc = "Toggle embedded" })
        vim.keymap.set("n", "<leader>oc", function() require("opencode").command() end, { desc = "Select command" })
        vim.keymap.set("n", "<leader>on", function() require("opencode").command("session_new") end,
            { desc = "New session" })
        vim.keymap.set("n", "<leader>oi", function() require("opencode").command("session_interrupt") end,
            { desc = "Interrupt session" })
        vim.keymap.set("n", "<leader>oA", function() require("opencode").command("agent_cycle") end,
            { desc = "Cycle selected agent" })
        vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("messages_half_page_up") end,
            { desc = "Messages half page up" })
        vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("messages_half_page_down") end,
            { desc = "Messages half page down" })
    end,
}
