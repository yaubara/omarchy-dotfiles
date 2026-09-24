return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    opts.formatters_by_ft.xml = { "xmlformatter" }
    opts.formatters_by_ft.php = function(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local home = vim.uv.os_homedir()

      -- Laravel
      if vim.fs.find({ "artisan" }, { upward = true, path = bufname, stop = home })[1] then
        return { "pint" }
      end

      -- WordPress
      local is_wp = string.match(bufname, "wp%-")
        or vim.fs.find({ "wp-config.php", "phpcs.xml" }, { upward = true, path = bufname, stop = home })[1]

      if is_wp then
        return { "phpcbf" }
      end

      -- По умолчанию
      return { "pint" }
    end

    opts.formatters = opts.formatters or {}

    opts.formatters.xmlformatter = {
      command = "xmlformat",
      args = { "--indent", "4", "-" },
      stdin = true,
    }

    opts.formatters.phpcbf = {
      command = "/home/yaubara/.config/composer/vendor/bin/phpcbf",
      args = function(_, ctx)
        local bufname = vim.api.nvim_buf_get_name(ctx.buf)
        local home = vim.uv.os_homedir()
        local root = vim.fs.find({ "phpcs.xml", "phpcs.xml.dist", ".phpcs.xml" }, {
          path = bufname,
          upward = true,
          stop = home,
        })[1]

        if root then
          return { "--standard=" .. root, "$FILENAME" }
        end
        return { "--standard=WordPress", "$FILENAME" }
      end,
      stdin = false,
      exit_codes = { 0, 1 },
    }

    opts.formatters.pint = {
      command = "pint",
      args = { "$FILENAME" },
      stdin = false,
    }

    return opts
  end,
}
