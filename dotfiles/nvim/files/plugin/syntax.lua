vim.pack.add({ 'https://github.com/darfink/vim-plist' })

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter'
})
require('nvim-treesitter').setup {
  ensure_installed = { 'javascript', 'swift', 'bash', 'java', 'kotlin', 'lua', 'markdown', 'json', 'html', 'go', 'gitignore', 'gitcommit', 'diff', 'css', 'dart', 'just' },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}
