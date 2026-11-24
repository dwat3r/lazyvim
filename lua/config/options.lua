-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.snacks_animate = false
vim.o.shell = "fish"

-- Lives here, not in autocmds.lua: autocmds load lazily and miss buffers opened at startup
vim.filetype.add({ filename = { Fastfile = "ruby", Appfile = "ruby" } })
