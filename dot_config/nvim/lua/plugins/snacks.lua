return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules" },
          },
          files = {
            hidden = true,
            ignored = true,
            exclude = { ".git", "node_modules" },
          },
        },
      },
    },
  },
}
