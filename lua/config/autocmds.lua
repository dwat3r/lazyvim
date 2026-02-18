-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_user_command("NextLint", function()
  print("Running next lint...")

  local output_lines = {}

  vim.fn.jobstart("pnpm next lint --format compact", {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data then
        vim.list_extend(output_lines, data)
      end
    end,

    on_stderr = function(_, data)
      if data then
        vim.list_extend(output_lines, data)
      end
    end,

    on_exit = function(_, exit_code)
      vim.schedule(function()
        local qf_list = {}

        for _, line in ipairs(output_lines) do
          if line ~= "" then
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
        end

        vim.fn.setqflist(qf_list)
        vim.cmd("copen")

        if #qf_list > 0 then
          print(string.format("Found %d lint issues", #qf_list))
        else
          print("No lint issues found")
        end
      end)
    end,
  })
end, {})

-- kanata grammar

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").kanata = {
      install_info = {
        url = "https://github.com/postsolar/tree-sitter-kanata",
        revision = "a6213d06ea6efa432702bbbc6b4c5dcddc21df2a", -- commit hash for revision to check out; HEAD if missing
        -- optional entries:
        branch = "master", -- only needed if different from default branch
        location = "parser", -- only needed if the parser is in subdirectory of a "monorepo"
        generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
        generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
        queries = "queries/neovim", -- also install queries from given directory
      },
    }
  end,
})

vim.treesitter.language.register("kanata", { "kbd" })

vim.filetype.add({
  extension = {
    kbd = "kanata",
  },
  filename = {
    ["kanata.kbd"] = "kanata",
  },
})
