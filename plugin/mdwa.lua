-- You can use this loaded variable to enable conditional parts of your plugin.
if _G.MdwaLoaded then
  return
end

_G.MdwaLoaded = true

-- Useful if you want your plugin to be compatible with older (<0.7) neovim versions
if vim.fn.has("nvim-0.7") == 0 then
  vim.cmd("command! Mdwa lua require('mdwa').reset()")
else
  vim.api.nvim_create_augroup("MDWA", { clear = true })
  vim.api.nvim_create_user_command("Mdwa", function(opts)
    require("mdwa").start(opts.args)
  end, { nargs = "?" })
end
