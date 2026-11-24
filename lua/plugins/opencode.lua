local function opencode_toggle()
  local opts = vim.g.opencode_opts or {}
  if opts.server and opts.server.toggle then
    opts.server.toggle()
  elseif opts.server and opts.server.start then
    opts.server.start()
  else
    vim.notify("OpenCode server not configured", vim.log.levels.ERROR, { title = "opencode" })
  end
end

local OPENCODE_CMD = "opencode -c"
local width_file = vim.fn.stdpath("state") .. "/opencode-width"

local function read_saved_width()
  local file = io.open(width_file, "r")
  if not file then
    return nil
  end
  local width = tonumber(file:read("*a"))
  file:close()
  return width
end

local function write_saved_width(width)
  local file = io.open(width_file, "w")
  if file then
    file:write(tostring(width))
    file:close()
  end
end

local last_width = read_saved_width()

local function remember_width(terminal)
  if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
    last_width = vim.api.nvim_win_get_width(terminal.win)
    terminal.opts.width = last_width
    write_saved_width(last_width)
  end
end

local function remember_open_panel_width()
  for _, terminal in ipairs(Snacks.terminal.list()) do
    if terminal.cmd == OPENCODE_CMD then
      remember_width(terminal)
    end
  end
end

local function terminal_win()
  return {
    position = "right",
    width = last_width or math.floor(vim.o.columns * 0.35),
    on_close = remember_width,
  }
end

local function prompt_key(lhs, prompt, desc)
  return {
    lhs,
    function()
      require("opencode").prompt(prompt, { submit = true })
    end,
    mode = { "n", "x" },
    desc = desc .. " (OpenCode)",
  }
end

local function ask_key(lhs, text, desc)
  return {
    lhs,
    function()
      require("opencode").ask(text, { submit = true })
    end,
    mode = { "n", "x" },
    desc = desc .. " (OpenCode)",
  }
end

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = { input = {}, picker = {}, terminal = {} },
    },
    {
      "folke/which-key.nvim",
      opts = {
        spec = {
          { "<leader>a", mode = { "n", "x" }, group = "OpenCode" },
          { "<leader>ap", mode = { "n", "x" }, group = "Prompt" },
        },
      },
    },
  },
  keys = {
    { "<leader>ao", opencode_toggle, desc = "Toggle (OpenCode)", mode = { "n", "v" } },
    { "<C-.>", opencode_toggle, desc = "Toggle Quick (OpenCode)", mode = { "n", "t", "v" } },
    {
      "<leader>ax",
      function()
        require("opencode").select()
      end,
      desc = "Action (OpenCode)",
      mode = { "n", "v" },
    },
    ask_key("<leader>aa", "@this: ", "Ask with context"),
    ask_key("<leader>ai", "", "Ask"),
    ask_key("<leader>ab", "@buffer: ", "Ask about buffer"),
    prompt_key("<leader>ape", "explain", "Explain"),
    prompt_key("<leader>apf", "fix", "Fix"),
    prompt_key("<leader>apd", "diagnose", "Diagnose"),
    prompt_key("<leader>apr", "review", "Review"),
    prompt_key("<leader>apt", "test", "Test"),
    prompt_key("<leader>apo", "optimize", "Optimize"),
    {
      "go",
      function()
        return require("opencode").operator("@this ")
      end,
      expr = true,
      mode = { "n", "x" },
      desc = "Add range (OpenCode)",
    },
    {
      "goo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      expr = true,
      mode = "n",
      desc = "Add line (OpenCode)",
    },
  },
  config = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(OPENCODE_CMD, { win = terminal_win() })
        end,
        toggle = function()
          require("snacks.terminal").toggle(OPENCODE_CMD, { win = terminal_win() })
        end,
      },
    }

    vim.o.autoread = true

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("opencode_panel_width", { clear = true }),
      desc = "Persist the OpenCode panel width when quitting with it open",
      callback = remember_open_panel_width,
    })
  end,
}
