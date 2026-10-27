vim.pack.add({ 'https://github.com/obsidian-nvim/obsidian.nvim' })

require('obsidian').setup({
  legacy_commands = false,
  workspaces = {
    { name = 'Obsidian', path = '~/Obsidian' },
  },
  frontmatter = { enabled = false },
  notes_subdir = 'pages',
  new_notes_location = 'notes_subdir',
  daily_notes = {
    folder = 'journals',
    date_format = '%Y-%m-%d',
  },
})

vim.cmd([[cnoreabbrev <expr> ot getcmdtype() == ':' && getcmdline() == 'ot' ? 'Obsidian today' : 'ot']])

vim.opt.conceallevel = 2
