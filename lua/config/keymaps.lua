-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>a", "<cmd>w<cr>", { desc = "Save" })

-- Delete file and buffer

local function delete_file_and_buffer()
  local confirm = vim.fn.confirm("Delete file and buffer?", "&Yes\n&No", 2)
  if confirm == 1 then
    local filepath = vim.fn.expand("%:p")
    os.remove(filepath)
    require("mini.bufremove").delete(0, false)
    vim.cmd("bnext")
    vim.notify("Deleted: " .. filepath, vim.log.levels.INFO)
  end
end

map("n", "<leader>fD", delete_file_and_buffer, { desc = "Delete file and buffer" })

--  stolen from helix
map({ "n", "v", "x" }, "gh", "0")
map({ "n", "v", "x" }, "gl", "$")
map({ "n", "v", "x" }, "U", "<C-r>")
