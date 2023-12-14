return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {
            ".git",
            "node_modules",
            ".cache",
            ".vscode",
            ".DS_Store",
            ".idea",
            ".vs",
            "thumbs.db",
          },
        },
      },
    },
  },
}
