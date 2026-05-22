vim.api.nvim_create_user_command('PluginUpdate', function() vim.pack.update() end, {})
vim.api.nvim_create_user_command('PluginClean', function()
  local inactive = {}
  for _, pkg in ipairs(vim.pack.get()) do
    if not pkg.active then
      table.insert(inactive, pkg.spec.name)
    end
  end
  if #inactive == 0 then
    vim.notify('No inactive plugins to remove')
    return
  end
  local lines = { 'Removing ' .. #inactive .. ' inactive plugins:' }
  for _, name in ipairs(inactive) do
    table.insert(lines, '  - ' .. name)
  end
  vim.notify(table.concat(lines, '\n'))
  vim.pack.del(inactive)
end, {})
