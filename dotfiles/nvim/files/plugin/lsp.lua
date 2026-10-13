vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/joechrisellis/lsp-format-modifications.nvim',
})

vim.pack.add({
  'https://github.com/folke/trouble.nvim'
})
require('trouble').setup()

vim.pack.add({
  'https://github.com/williamboman/mason.nvim'
})
require('mason').setup()

vim.pack.add({
  'https://github.com/williamboman/mason-lspconfig.nvim'
})
require('mason-lspconfig').setup()

require('lazydev').setup()


local on_attach = function(client, bufnr)
  local function set_normal_keymap(from, to)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', from, '<cmd> lua ' .. to .. '<CR>', opts)
  end

  set_normal_keymap('gD', 'vim.lsp.buf.declaration()')
  set_normal_keymap('gd', 'vim.lsp.buf.definition()')
  set_normal_keymap('K', 'vim.lsp.buf.hover()')
  set_normal_keymap('gi', 'vim.lsp.buf.implementation()')
  set_normal_keymap('<C-k>', 'vim.lsp.buf.signature_help()')
  set_normal_keymap('<space>wa', 'vim.lsp.buf.add_workspace_folder()')
  set_normal_keymap('<space>wr', 'vim.lsp.buf.remove_workspace_folder()')
  set_normal_keymap('<space>wl', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
  set_normal_keymap('<space>D', 'vim.lsp.buf.type_definition()')
  set_normal_keymap('<space>rn', 'vim.lsp.buf.rename()')
  set_normal_keymap('<space>ca', 'vim.lsp.buf.code_action()')
  set_normal_keymap('gr', 'vim.lsp.buf.references()')
  set_normal_keymap('<space>f', 'vim.lsp.buf.format()')
  set_normal_keymap('<space>d', 'vim.diagnostic.open_float()')

  local augroup_id = vim.api.nvim_create_augroup(
    "FormatModificationsDocumentFormattingGroup",
    { clear = false }
  )
  vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })

  vim.api.nvim_create_autocmd(
    { "BufWritePre" },
    {
      group = augroup_id,
      buffer = bufnr,
      callback = function()
        local lsp_format_modifications = require"lsp-format-modifications"
        lsp_format_modifications.format_modifications(client, bufnr)
      end,
    }
  )
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
