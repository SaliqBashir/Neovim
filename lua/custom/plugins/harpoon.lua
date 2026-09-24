---@module 'lazy'
---@type LazySpec
return {
  { -- Quick file/mark navigation
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' }, -- already pulled in by telescope, declared explicitly anyway
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function() harpoon:list():append() end, { desc = 'Harpoon Add File' })
      vim.keymap.set('n', '<leader>r', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon Quick Menu' })

      vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)
    end,
  },
}
