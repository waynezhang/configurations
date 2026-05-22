vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-symbols.nvim',
  'https://github.com/chrisbra/matchit',
})

vim.pack.add({
  'https://github.com/FluxxField/smart-motion.nvim'
})
require("smart-motion").setup({
  native_search = false,
  keys = "fjdksleirughtynmcvbxzaoqp",
  flow_state_timeout_ms = 0,
  dim_background = false,
})
require("smart-motion.motions").register_motion("<leader><leader>w", {
  collector = "lines",
  extractor = "words",
  filter = "filter_visible",
  visualizer = "hint_start",
  action = "jump",
  map = true,
  modes = {
    n = {
      word_pattern = [[\v(\w+)]],
    }
  },
  metadata = {
    motion_state = {
      multi_window = false,
      virt_text_pos = 'overlay',
    },
  },
})

vim.pack.add({ 'https://github.com/kyoh86/vim-ripgrep' })
vim.api.nvim_create_user_command(
  'Rg',
  function(opts)
    local arg = opts.args
    if (arg == '') then
      arg = vim.fn['expand']('<cword>')
    end
    vim.fn['ripgrep#search'](arg)
  end,
  { nargs = '*' }
)

vim.pack.add({ 'https://github.com/yamatsum/nvim-cursorline' })
require('nvim-cursorline').setup {
  cursorword = { enable = true }
}
