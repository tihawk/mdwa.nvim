local main = require("mdwa.main")
local config = require("mdwa.config")

local Mdwa = {}

function Mdwa.start(args)
  if _G.Mdwa.config == nil then
    _G.Mdwa.config = config.options
  end

  local duration_mins = _G.Mdwa.config.default_duration / 60
  local args_duration_mins = tonumber(args)
  if args_duration_mins and type(args_duration_mins) == "number" then
    duration_mins = args_duration_mins
  end
  if config.options.use_tabs == true then
    vim.cmd("tabnew")
  end
  vim.cmd("enew")
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "", "", "" })
  local buf_nr = vim.api.nvim_get_current_buf()
  main.create_autocmds(buf_nr)
  main.setup("public_api_start", duration_mins * 60)
end

-- Setup Mdwa options and merge them with user provided ones.
function Mdwa.setup(opts)
  _G.Mdwa.config = config.setup(opts)
end

_G.Mdwa = Mdwa

return _G.Mdwa
