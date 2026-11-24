return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqls = {},
      },
    },
  },
  {
    "jmbuhr/otter.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
  },
}
