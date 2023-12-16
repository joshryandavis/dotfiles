return {
  {
    "nvim-tree/nvim-web-devicons",
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
  },

  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
  },
}
