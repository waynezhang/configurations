vim.pack.add({
  'https://github.com/CRAG666/code_runner.nvim',
})

require('code_runner').setup {
  filetype = {
    python = "python3 -u \"$fileName\"",
    typescript = "deno run",
    swift = "swift",
  },
}
