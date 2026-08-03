local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local state = require("telescope.actions.state")

local sessions = require("resession")
local M = {}

function M.picker()

  local names = sessions.list()
  pickers.new({}, {
    prompt_title = "Sessions",
    finder = finders.new_table {
      results = names,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(buf)
        local entry = state.get_selected_entry()
        actions.close(buf)
        sessions.load(entry[1])
      end)
      return true
    end,
  }):find()

end

return M
