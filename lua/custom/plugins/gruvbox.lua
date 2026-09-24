---@module 'lazy'
---@type LazySpec
return {
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- load before other start plugins
    config = function()
      require('gruvbox').setup {
        contrast = 'hard',
        transparent_mode = false,
      }
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
}
