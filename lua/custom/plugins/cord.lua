---@module 'lazy'
---@type LazySpec
return {
  { 'vyfor/cord.nvim', cond = vim.env.NVIM_DISCORD == '1', opts = {} }, -- Discord rich presence (opt-in: export NVIM_DISCORD=1)
}
