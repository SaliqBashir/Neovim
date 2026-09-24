---@module 'lazy'
---@type LazySpec
return {
  { -- Auto-close and auto-rename HTML/JSX tags as you type
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPost', 'BufNewFile' },
    ft = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
    opts = {},
  },
}
