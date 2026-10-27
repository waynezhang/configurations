vim.pack.add({
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-vsnip',
  'https://github.com/hrsh7th/vim-vsnip',
})

vim.pack.add({ 'https://github.com/m4xshen/autoclose.nvim' })
require('autoclose').setup()

vim.pack.add({
  'https://github.com/davidsierradz/cmp-conventionalcommits',
  'https://github.com/hrsh7th/nvim-cmp'
})
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  view = {
    entries = "native"
  },
  sources = cmp.config.sources(
    { { name = 'nvim_lsp' } },
    { { name = 'buffer' } },
    { { name = 'vsnip' } }
  )
})

cmp.setup.filetype('markdown', {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
})

cmp.setup.filetype({ "gitcommit", "NeogitCommitMessage" }, {
  sources = {
    { name = "conventionalcommits" },
    { name = "async_path" },
  },
  { name = "buffer" },
})
