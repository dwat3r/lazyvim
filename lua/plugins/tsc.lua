return {
  "dmmulroy/tsc.nvim",
  config = function()
    require("tsc").setup({
      -- Your config here
      run_as_monorepo = true,
      use_trouble_qflist = true,
    })
  end,
}
