----- Buffer Helpers: Bash Execution ------------------------------------------
require('plugin-configuration')
--- Run current line and insert output below.
vim.keymap.set("n", "<leader>rl", function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = vim.api.nvim_get_current_line()
  if cmd == "" then
    return
  end

  local blocked = {
    "^n?vim$",
    "^n?vim%s",
    "^vi%s",
    "^vi$",
    "^less$",
    "^less%s",
    "^more$",
    "^more%s",
    "^top$",
    "^htop$",
    "^fzf$",
    "^fzf%s",
  }

  for _, pat in ipairs(blocked) do
    if cmd:match(pat) then
      vim.notify("Refusing interactive command: " .. cmd, vim.log.levels.WARN)
      return
    end
  end

  local output = vim.fn.systemlist({ "bash", "-c", cmd })
  vim.api.nvim_buf_set_lines(0, line, line, false, output)

  if vim.v.shell_error ~= 0 then
    vim.notify("Command exited with code " .. vim.v.shell_error, vim.log.levels.WARN)
  end
end, { desc = "Run current line and insert output below" })

local active_job = nil

--- Stream current line output below.
vim.keymap.set("n", "<leader>rs", function()
  if active_job then
    vim.notify("A streaming job is already running", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cmd = vim.api.nvim_get_current_line()

  if cmd == "" then
    return
  end

  local function append_data(_, data)
    if not data or vim.tbl_isempty(data) then
      return
    end

    -- job callbacks often include a final empty item; trim it
    if data[#data] == "" then
      table.remove(data, #data)
    end
    if vim.tbl_isempty(data) then
      return
    end

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_set_lines(bufnr, row, row, false, data)
        row = row + #data
      end
    end)
  end

  active_job = vim.fn.jobstart({ "bash", "-c", cmd }, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = append_data,
    on_stderr = append_data,
    on_exit = function(_, code)
      vim.schedule(function()
        active_job = nil
        vim.notify("Job exited with code " .. code)
      end)
    end,
  })
end, { desc = "Stream current line output below" })

--- Stop streaming job.
vim.keymap.set("n", "<leader>rc", function()
  if active_job then
    vim.fn.jobstop(active_job)
    active_job = nil
  end
end, { desc = "Stop streaming job" })
