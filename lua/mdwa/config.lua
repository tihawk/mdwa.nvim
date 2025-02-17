local log = require("mdwa.util.log")

local Mdwa = {}

--- Mdwa configuration with its default values.
---
---@type table
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
Mdwa.options = {
  debug = false,
  default_duration = 180, -- 3 minutes
  max_inactivity = 5,
  use_tabs = true,
  colors = {
    bad = { "#ff0033", "#e5002d", "#cc0028", "#b20023", "#7f0019" },
    good = "#3b474a",
  },
  symbols = {
    empty_bar = "░",
    filled_bar = "█",
  },
}

---@private
local defaults = vim.deepcopy(Mdwa.options)

--- Defaults Mdwa options by merging user provided options with the default plugin values.
---
---@param options table Module config table. See |Mdwa.options|.
---
---@private
function Mdwa.defaults(options)
  Mdwa.options = vim.deepcopy(vim.tbl_deep_extend("keep", options or {}, defaults or {}))

  -- let your user know that they provided a wrong value, this is reported when your plugin is executed.
  assert(type(Mdwa.options.debug) == "boolean", "`debug` must be a boolean (`true` or `false`).")
  assert(
    type(Mdwa.options.default_duration) == "number",
    "`default_duration` must be a number (in seconds)."
  )
  assert(
    type(Mdwa.options.max_inactivity) == "number",
    "`max_inactivity` must be a number (in seconds)."
  )

  return Mdwa.options
end

--- Define your mdwa setup.
---
---@param options table Module config table. See |Mdwa.options|.
---
---@usage `require("mdwa").setup()` (add `{}` with your |Mdwa.options| table)
function Mdwa.setup(options)
  Mdwa.options = Mdwa.defaults(options or {})

  log.warn_deprecation(Mdwa.options)

  return Mdwa.options
end

return Mdwa
