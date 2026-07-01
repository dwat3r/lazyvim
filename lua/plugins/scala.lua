return {
  {
    "scalameta/nvim-metals",
    opts = function(_, metals_config)
      metals_config.init_options.statusBarProvider = "on"
      metals_config.on_attach = function(client, bufnr)
        if pcall(require, "dap") then
          require("metals").setup_dap()
        end
      end
      return metals_config
    end,
    keys = {
      {
        "<leader>me",
        function()
          require("metals").commands()
        end,
        desc = "Metals commands",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return vim.g["metals_status"] or ""
        end,
        cond = function()
          return vim.bo.filetype == "scala" or vim.bo.filetype == "sbt"
        end,
      })
    end,
  },
}
