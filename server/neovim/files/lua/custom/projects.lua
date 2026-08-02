local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

function M.find_projects(opts)
  opts = opts or {}

  local cmd = {
    "fd", "--hidden", "--type", "dir",
    "--max-depth", "2",
    "--exclude", ".local",
    "--exclude", ".vim",
    "^\\.git$",
    "--search-path", vim.env.HOME,
    "--search-path", "/mnt/k95vb/ytdl_rdgf_script/",
    "--search-path", "/mnt/k95vb/s21/",
  }

  pickers.new(opts, {
    prompt_title = "Projects",
    finder = finders.new_oneshot_job(cmd, {
      entry_maker = function(line)
        -- line = /home/user/repo/.git -> repo path is dirname
        local repo = line:gsub("/%.git/?$", "")
        return {
          value = repo,
          display = repo:gsub("^" .. vim.env.HOME, "~"),
          ordinal = repo,
        }
      end,
    }),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if not selection then return end
        vim.cmd("cd " .. vim.fn.fnameescape(selection.value))
        require("telescope.builtin").find_files({ cwd = selection.value })
      end)
      return true
    end,
  }):find()
end

return M
