local log = require("mdwa.util.log")
local state = require("mdwa.state")

-- Internal methods
local main = {}

--- Initializes the plugin, sets event listeners and internal state.
---
--- @param scope string: internal identifier for logging purposes.
---@private
function main.clear(scope)
  log.debug(scope, "clearing mdwa")
  main.reset_background(scope)
  state.clear(state)
  -- Saves the state globally to `_G.Mdwa.state`
  state.save(state)
end

--- Initializes the plugin, sets event listeners and internal state.
---
--- @param scope string: internal identifier for logging purposes.
--- @param duration number: mdwa session duration in seconds.
---@private
function main.setup(scope, duration)
  log.debug(scope, "setting up mdwa")
  main.reset_background(scope)
  vim.cmd("setlocal winhighlight=Normal:MDWAbg")
  state.setup(state, duration, function()
    main.check_inactivity()
    main.update_virtual_text()
  end)
  state.save(state)
end

--- Initializes the plugin, sets event listeners and internal state.
---
--- @param scope string: internal identifier for logging purposes.
---@private
function main.reset(scope)
  log.debug(scope, "resetting mdwa")
  main.reset_background(scope)
  state.reset(state)
  state.save(state)
end

--- Resets background colour
---
--- @param scope string: internal identifier for logging purposes.
---@private
function main.reset_background(scope)
  log.debug(scope, "resetting background colour")
  vim.cmd("highlight! link MDWABg Normal")
end

--- Clears virtual text
---
--- @param scope string: internal identifier for logging purposes.
---@private
function main.clear_virtual_text(scope)
  log.debug(scope, "clearing virtual text with clear_namespace")
  vim.api.nvim_buf_clear_namespace(0, state.ns_id, 0, -1)
end

--- Creates auto_commands
---
--- @param buf_nr any: Buffer number.
---@private
function main.create_autocmds(buf_nr)
  vim.api.nvim_create_autocmd("InsertCharPre", {
    buffer = buf_nr,
    callback = function()
      if state.inactivity >= _G.Mdwa.config.max_inactivity or state.remaining_time <= 0 then
        return
      end
      main.reset("private_api_died")
    end,
    group = "MDWA",
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf_nr,
    callback = function()
      main.remove_autocmds()
      main.clear_virtual_text("private_api_closing_buffer")
      main.clear("private_api_closing_buffer")
    end,
    group = "MDWA",
  })
end

--- Removes auto_commands
---
---@private
function main.remove_autocmds()
  vim.api.nvim_clear_autocmds({ group = "MDWA" })
end

function main.update_virtual_text()
  local minutes = math.floor(state.remaining_time / 60)
  local seconds = state.remaining_time % 60
  local inactivity_seconds = _G.Mdwa.config.max_inactivity - state.inactivity
  local text =
    string.format("MDWA Mode: %02d:%02d | Inactivity: %d", minutes, seconds, inactivity_seconds)

  local win_width = vim.api.nvim_win_get_width(0) -- Get the current window width
  local total_blocks = win_width -- Number of blocks in the progress bar is equal to the window width
  local filled_blocks =
    math.floor((state.duration - state.remaining_time) / state.duration * total_blocks)
  local progress_bar = string.rep("|", filled_blocks)
    .. string.rep("░", total_blocks - filled_blocks)

  vim.api.nvim_buf_clear_namespace(0, state.ns_id, 0, 2)
  local hl_group = "Comment"
  if state.remaining_time <= (state.duration / 3 * 2) then
    hl_group = "WarningMsg"
  end
  if state.remaining_time <= (state.duration / 3) then
    hl_group = "diffAdded"
  end
  vim.api.nvim_buf_set_extmark(0, state.ns_id, 0, 0, {
    virt_text = { { progress_bar, hl_group } },
    hl_mode = "combine",
  })
  vim.api.nvim_buf_set_extmark(0, state.ns_id, 1, 0, {
    virt_text = { { text, "WarningMsg" } },
    hl_mode = "combine",
  })
end

function main.check_inactivity()
  state.inactivity = state.inactivity + 1
  state.remaining_time = state.remaining_time - 1
  if state.inactivity >= _G.Mdwa.config.max_inactivity then
    vim.cmd("normal! ggdG") -- Delete all text in the buffer
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "", "", "" }) -- Insert a few empty lines at the top
    vim.cmd("highlight MDWABg guibg=#FF0000") -- Make the background fully red as just ran out and deleted text
    if state.timer then
      state.timer:stop()
    end
    return
  end
  if state.remaining_time <= 0 then
    vim.cmd("highlight MDWABg guibg=#3b474a") -- Turn background green
    if state.timer then
      state.timer:stop()
    end
    return
  end
  local seconds_left = _G.Mdwa.config.max_inactivity - state.inactivity
  -- TODO make it proportional to the time left, instead of hard-coded
  if seconds_left <= 3 then
    local colors = {
      [4] = "#de7371", -- 3 seconds left
      [3] = "#e96866", -- 2 second left
      [2] = "#f45e5b", -- 1 second left
      [1] = "#ff5350", -- 0 seconds left
    }
    local color_index = seconds_left + 1
    vim.cmd("highlight MDWABg guibg=" .. colors[color_index])
  end
end

return main
