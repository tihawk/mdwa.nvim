-- Global variables to track state
---@type { stop: function, start: function } | nil
local mdwa_timer = nil
local mdwa_inactivity = 0
local mdwa_duration = 180 -- 3 minutes
local mdwa_max_inactivity = 6 -- 5 seconds
local mdwa_remaining_time = mdwa_duration
local ns_id = vim.api.nvim_create_namespace("mdwa_namespace")

local function MDWA_reset_background()
  vim.cmd("highlight! link MDWABg Normal")
end

MDWA_reset_background()

local function MDWA_clear()
  MDWA_reset_background() -- Reset background color
  mdwa_inactivity = 0
  mdwa_remaining_time = mdwa_duration
  if mdwa_timer then
    mdwa_timer:stop()
    mdwa_timer = nil
  end
end

vim.api.nvim_create_augroup("MDWA", { clear = true })

local function MDWA_clear_virtual_text()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

local function MDWA_check_inactivity()
  mdwa_inactivity = mdwa_inactivity + 1
  mdwa_remaining_time = mdwa_remaining_time - 1
  if mdwa_inactivity >= mdwa_max_inactivity then
    vim.cmd("normal! ggdG") -- Delete all text in the buffer
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "", "", "" }) -- Insert a few empty lines at the top
    vim.cmd("highlight MDWABg guibg=#FF0000") -- Make the background fully red as just ran out and deleted text
    if mdwa_timer then
      mdwa_timer:stop()
    end
    -- MDWA_clear_virtual_text()
    return
  end
  if mdwa_remaining_time <= 0 then
    vim.cmd("highlight MDWABg guibg=#3b474a") -- Turn background green
    if mdwa_timer then
      mdwa_timer:stop()
    end
    -- MDWA_clear_virtual_text()
    return
  end
  local seconds_left = mdwa_max_inactivity - mdwa_inactivity
  if seconds_left <= 3 then
    local colors = {
      -- [5] = '#FFEEEE', -- 4 seconds left
      -- [4] = '#FFCCCC', -- 3 seconds left
      [4] = "#FF9999", -- 3 seconds left
      [3] = "#FF6666", -- 2 second left
      [2] = "#FF4D4D", -- 1 second left
      [1] = "#FF0000", -- 0 seconds left
    }
    local color_index = seconds_left + 1
    vim.cmd("highlight MDWABg guibg=" .. colors[color_index])
  end
end

local function MDWA_update_virtual_text()
  local minutes = math.floor(mdwa_remaining_time / 60)
  local seconds = mdwa_remaining_time % 60
  local inactivity_seconds = mdwa_max_inactivity - mdwa_inactivity
  local text =
    string.format("MDWA Mode: %02d:%02d | Inactivity: %d", minutes, seconds, inactivity_seconds)

  local win_width = vim.api.nvim_win_get_width(0) -- Get the current window width
  local total_blocks = win_width -- Number of blocks in the progress bar is equal to the window width
  local filled_blocks =
    math.floor((mdwa_duration - mdwa_remaining_time) / mdwa_duration * total_blocks)
  local progress_bar = string.rep("█", filled_blocks)
    .. string.rep("░", total_blocks - filled_blocks)

  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, 2)
  local hl_group = "Comment"
  if mdwa_remaining_time <= (mdwa_duration / 3 * 2) then
    hl_group = "WarningMsg"
  end
  if mdwa_remaining_time <= (mdwa_duration / 3) then
    hl_group = "diffAdded"
  end
  vim.api.nvim_buf_set_extmark(0, ns_id, 0, 0, {
    virt_text = { { progress_bar, hl_group } },
    hl_mode = "combine",
  })
  vim.api.nvim_buf_set_extmark(0, ns_id, 1, 0, {
    virt_text = { { text, "WarningMsg" } },
    hl_mode = "combine",
  })
end

local function MDWA_setup()
  MDWA_reset_background() -- Reset background color
  vim.cmd("setlocal winhighlight=Normal:MDWABg") -- Set the buffer to use MDWABg highlight group
  mdwa_inactivity = 0
  mdwa_remaining_time = mdwa_duration
  if mdwa_timer then
    mdwa_timer:stop()
  end
  mdwa_timer = vim.uv.new_timer()
  mdwa_timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      MDWA_check_inactivity()
      MDWA_update_virtual_text()
    end)
  )
end

local function MDWA_reset()
  mdwa_inactivity = 0
  MDWA_reset_background() -- Reset background color
end

local function MDWA_remove_autocmds()
  vim.api.nvim_clear_autocmds({ group = "MDWA" })
end

local function MDWA_create_autocmds(bufnr)
  vim.api.nvim_create_autocmd("InsertCharPre", {
    buffer = bufnr,
    callback = function()
      -- if ran out of time, do not reset if type character as want to leave red background
      -- same for if successfully completed the time leave green background
      if mdwa_inactivity >= mdwa_max_inactivity or mdwa_remaining_time <= 0 then
        return
      end
      MDWA_reset()
    end,
    group = "MDWA",
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = bufnr,
    callback = function()
      MDWA_remove_autocmds()
      MDWA_clear_virtual_text()
      MDWA_clear()
    end,
    group = "MDWA",
  })
end

vim.api.nvim_create_user_command("MdwaNew", function(opts)
  local duration_minutes = mdwa_duration / 60
  local args_min = tonumber(opts.args)
  if args_min and type(args_min) == "number" then
    duration_minutes = args_min
  end
  mdwa_duration = duration_minutes * 60
  vim.cmd("tabnew") -- Create a new tab
  vim.cmd("enew") -- Create a new buffer
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "", "", "" }) -- Insert a couple of empty lines at the top
  local bufnr = vim.api.nvim_get_current_buf() -- Get the buffer number
  MDWA_create_autocmds(bufnr) -- Create autocmds for this buffer
  MDWA_setup() -- Start the MDWA mode
end, { nargs = "?" })
