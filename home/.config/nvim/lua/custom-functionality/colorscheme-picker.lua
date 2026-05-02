----- Telescoped Colorscheme Picker -------------------------------------------
local function pick_colorscheme()
  local builtin = require('telescope.builtin')
  local themes = require('telescope.themes')
  builtin.colorscheme(themes.get_dropdown { enable_preview = true })
end

return pick_colorscheme
