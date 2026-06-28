----- Terminal Mode Improvements ----------------------------------------------
-- Convenience alias
local map = vim.keymap.set

local function open_terminal(layout, cmd)
  vim.cmd(layout)

  if cmd == nil or cmd == "" then
    vim.cmd.terminal()
  else
    vim.fn.termopen(cmd)
  end

  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command("TabTerm", function(opts)
  open_terminal("tabnew", opts.args)
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Open a terminal in a new tab",
})

vim.api.nvim_create_user_command("VTerm", function(opts)
  open_terminal("vsplit", opts.args)
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Open a terminal in a vertical split",
})

map("n", "<leader>tt", "<cmd>TabTerm<CR>", {
  desc = "Open terminal in new tab",
  silent = true,
})

map("n", "<leader>tv", "<cmd>VTerm<CR>", {
  desc = "Open terminal in vertical split",
  silent = true,
})

map("n", "<leader>tc", "<cmd>VTerm codex<CR>", {
  desc = "Open Codex terminal in vertical split",
  silent = true,
})

-- In terminal mode, <C-\><C-n> is the built-in way to get back to Normal mode.
-- This makes plain <Esc> do that instead, so leaving a terminal is one keypress.
--
-- Caveat:
-- Some terminal apps / TUIs really do want a raw Escape key.
-- If that ever gets annoying, remove this mapping or choose a different key.
map("t", "§", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
  silent = true,
})

----- Window Movement Improvements --------------------------------------------
-- Use the same keys to move between windows from Normal, Insert, and Terminal mode.
-- This is especially nice when you treat Neovim like a little window manager.
--
-- Normal mode:
--   <A-h> / <A-j> / <A-k> / <A-l> behave like <C-w>h/j/k/l
--
-- Insert mode:
--   leaves Insert mode, then moves to the target window
--
-- Terminal mode:
--   leaves Terminal-job mode, then moves to the target window
local directions = {
  h = "left",
  j = "down",
  k = "up",
  l = "right",
}

for key, dir in pairs(directions) do
  -- Normal mode window navigation
  map("n", "<A-" .. key .. ">", "<C-w>" .. key, {
    desc = "Go to " .. dir .. " window",
    silent = true,
  })

  -- Insert mode window navigation:
  -- first return to Normal mode, then do the window command
  map("i", "<A-" .. key .. ">", "<C-\\><C-n><C-w>" .. key, {
    desc = "Go to " .. dir .. " window from Insert mode",
    silent = true,
  })

  -- Terminal mode window navigation:
  -- first return to Normal mode, then do the window command
  map("t", "<A-" .. key .. ">", [[<C-\><C-n><C-w>]] .. key, {
    desc = "Go to " .. dir .. " window from Terminal mode",
    silent = true,
  })
end

----- Tab Movement Improvements -----------------------------------------------
-- Shifted Alt+h/j/k/l arrives in Neovim as Alt+H/J/K/L in most terminals.
--
--   <A-H> / <A-L> move between tabs
--   <A-J> / <A-K> move the current tab left/right
local tab_mappings = {
  H = { command = "tabprevious", desc = "Go to previous tab" },
  L = { command = "tabnext", desc = "Go to next tab" },
  J = { command = "tabmove -1", desc = "Move tab left" },
  K = { command = "tabmove +1", desc = "Move tab right" },
}

for key, mapping in pairs(tab_mappings) do
  local command = "<cmd>" .. mapping.command .. "<CR>"

  map("n", "<A-" .. key .. ">", command, {
    desc = mapping.desc,
    silent = true,
  })

  map("i", "<A-" .. key .. ">", "<C-\\><C-n>" .. command, {
    desc = mapping.desc .. " from Insert mode",
    silent = true,
  })

  map("t", "<A-" .. key .. ">", [[<C-\><C-n>]] .. command, {
    desc = mapping.desc .. " from Terminal mode",
    silent = true,
  })
end
