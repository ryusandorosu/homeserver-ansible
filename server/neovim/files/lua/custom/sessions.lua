local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local state = require("telescope.actions.state")

local sessions = require("resession")
local home = vim.uv.os_homedir()
local function short(path)
  return path:gsub("^" .. vim.pesc(home), "~")
end

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
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.90,
      height = 0.90,
      preview_width = 0.67,
    },
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
        local fd = vim.uv.fs_open(entry.value.path, "r", 438)
        local stat = vim.uv.fs_fstat(fd)
        local text = vim.uv.fs_read(fd, stat.size, 0)
        vim.uv.fs_close(fd)
        local json = vim.json.decode(text)
        local lines = {
          "Session",
          "  " .. entry.value.name,
          "",
          "Saved",
          "  " .. os.date("%c", entry.value.mtime),
          "",
          "Working directory",
          "  " .. short(json.global.cwd),
          "",
          string.format("Buffers (%d)", #json.buffers),
          "",
        }
        for _, buf in ipairs(json.buffers) do
          table.insert(lines, "• " .. short(buf.name))
        end
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        local buf = self.state.bufnr
        -- vim.api.nvim_buf_add_highlight(buffer, namespace, highlight, line, start_col, end_col)
        vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1) --Session
        vim.api.nvim_buf_add_highlight(buf, -1, "Title", 3, 0, -1) --Saved
        vim.api.nvim_buf_add_highlight(buf, -1, "Title", 6, 0, -1) --Working directory
        vim.api.nvim_buf_add_highlight(buf, -1, "Title", 9, 0, -1) --Buffers (count)
        vim.bo[self.state.bufnr].modifiable = false
        vim.bo[self.state.bufnr].filetype = "markdown"
        vim.wo[self.state.winid].wrap = true
        vim.wo[self.state.winid].linebreak = true
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
