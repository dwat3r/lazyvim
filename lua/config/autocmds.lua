-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_user_command("NextLint", function()
  local output = vim.fn.system("pnpm next lint --format compact")
  local lines = vim.split(output, "\n")
  local qf_list = {}

  for _, line in ipairs(lines) do
    -- Parse next lint output format
    local file, lnum, col, text = line:match("(.+): line ([0-9]+), col ([0-9]+), (.+)")
    if file then
      table.insert(qf_list, {
        filename = file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      })
    end
  end

  vim.fn.setqflist(qf_list)
  vim.cmd("copen")
end, {})
