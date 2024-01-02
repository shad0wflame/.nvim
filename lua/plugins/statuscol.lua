return {
  "luukvbaal/statuscol.nvim",
  dependencies = {
    {
      "lewis6991/gitsigns.nvim",
      tag = "v0.6",
    },
  },
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup()

    -- Folding options
    vim.opt.foldlevel = 99
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.wo.foldcolumn = "1"
    vim.o.statuscolumn = "%l%s%C"

    vim.opt.list = true;
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      segments = {
        { text = { "%s" }, click = "v:lua.ScSa" },
        { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
        {
          text = { " ", builtin.foldfunc, " " },
          condition = { builtin.not_empty, true, builtin.not_empty },
          click = "v:lua.ScFa"
        },
      },
    })
  end
}
