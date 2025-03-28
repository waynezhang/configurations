return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'javascript', 'swift', 'bash', 'java', 'kotlin', 'lua', 'markdown', 'json', 'html', 'go', 'gitignore', 'gitcommit', 'diff', 'css', 'dart', 'just' },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
    end,
  },
  'darfink/vim-plist',
}
