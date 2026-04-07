return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>ff",
        function()
          Snacks.picker.files({ hidden = true, ignored = true })
        end,
        desc = "Find Files (hidden + ignored)",
      },
    },
  },
}
