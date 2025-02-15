local log = require("mdwa.util.log")

local state = {
  duration = nil,
  ---@type { stop: function, start: function } | nil
  timer = nil,
  inactivity = 0,
  remaining_time = nil,
  ns_id = vim.api.nvim_create_namespace("self.namespace"),
}

---Resets the state to its original value.
---
---@private
function state:clear()
  if self.timer then
    self.timer:stop()
    self.timer = nil
  end
  self.duration = nil
  self.inactivity = 0
  self.remaining_time = nil
end

---Sets the state to its original value.
---
---@param duration number: mdwa session duration in seconds
---@param callback function: Callback for each second while timer is running
---@private
function state:setup(duration, callback)
  if self.timer then
    self.timer:stop()
  end
  self.inactivity = 0
  self.duration = duration
  self.remaining_time = duration
  self.timer = vim.uv.new_timer()
  self.timer:start(1000, 1000, vim.schedule_wrap(callback))
end

---Resets the inactivity timer if the user started typing before dying.
---
---@private
function state:reset()
  self.inactivity = 0
end

---Saves the state in the global _G.Mdwa.state object.
---
---@private
function state:save()
  log.debug("state.save", "saving state globally to _G.Mdwa.state")

  _G.Mdwa.state = self
end

return state
