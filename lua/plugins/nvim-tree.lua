return {
	'nvim-tree/nvim-tree.lua',
	dependencies = {
		'nvim-tree/nvim-web-devicons'
  },
  config = function ()
    require("nvim-tree").setup({
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      }
    })

    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    vim.keymap.set("n", "<leader>1", ":NvimTreeFocus<CR>", { silent = true })
  end
}
