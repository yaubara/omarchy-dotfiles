return {
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile", -- Loads the plugin when you open a file
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      -- Individual filetype configs
      -- per_filetype = {
      --   ["html"] = {
      --     enable_close = false,
      --   },
      -- },
    },
  },
}
