return {
    'zbirenbaum/copilot.lua',
    version = '*',
    event = 'InsertEnter',
    config = function()
        require('copilot').setup({
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = false,
                },
            }
        })
        vim.keymap.set("i", '<C-CR>', function()
            if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-CR>", true, false, true), "n", false)
            end
        end, {
            silent = true,
        })
    end,
}
