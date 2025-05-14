return {
	'akinsho/bufferline.nvim',
	version = '*',
	dependencies = 'nvim-tree/nvim-web-devicons',
  config = function ()
    vim.api.nvim_command("autocmd FileType qf set nobuflisted");

    require("bufferline").setup({
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "Nvim Tree",
            separator = true
          }
        },
      }
    })
  end
}
