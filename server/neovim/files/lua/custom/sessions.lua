local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local state = require("telescope.actions.state")

local sessions = require("resession")
local M = {}

function M.picker()

  local uv = vim.uv or vim.loop
  local dir = vim.fn.stdpath("data") .. "/resession"
  local entries = {}

  for _, name in ipairs(sessions.list()) do
    local file = dir .. "/" .. name .. ".json"
    local stat = uv.fs_stat(file)
    table.insert(entries, {
      name = name,
      path = file,
      mtime = stat and stat.mtime.sec or 0,
    })
  end

  table.sort(entries, function(a, b)
    return a.mtime > b.mtime
  end)

  pickers.new({}, {
    prompt_title = "Sessions",
    finder = finders.new_table {
      results = entries,
      entry_maker = function(item)
        return {
          value = item,
          ordinal = item.name,
          display = string.format(
            "%s %s",
            os.date("%Y-%m-%d %H:%M", item.mtime),
            item.name
          ),
        }
      end,
    },
    previewer = require("telescope.previewers").new_buffer_previewer({
      define_preview = function(self, entry)
        local json = vim.fn.json_decode(
          table.concat(vim.fn.readfile(entry.value.path), "\n")
        )
        local lines = {}
        table.insert(lines, "Session : " .. entry.value.name)
        table.insert(lines, "Saved   : " ..
          os.date("%c", entry.value.mtime))
        table.insert(lines, "")
        table.insert(lines, "cwd:")
        table.insert(lines, "  " .. json.global.cwd)
        table.insert(lines, "")
        table.insert(lines, "buffers:")
        table.insert(lines, "")
        for _, buf in ipairs(json.buffers) do
          table.insert(lines, "• " .. buf.name)
        end
        vim.api.nvim_buf_set_lines(
          self.state.bufnr,
          0,
          -1,
          false,
          lines
        )
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(buf)
        local entry = state.get_selected_entry()
        actions.close(buf)
        sessions.load(entry.value.name)
      end)
      return true
    end,
  }):find()

end

return M
