return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- 1. Назначаем линтеры по типам файлов
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.markdown = { "markdownlint-cli2" }
    opts.linters_by_ft.php = { "phpcs" }

    -- 2. Настраиваем конкретные линтеры
    opts.linters = opts.linters or {}

    -- Настройка для Markdown
    opts.linters["markdownlint-cli2"] = {
      condition = function(ctx)
        local config_files = {
          ".markdownlint-cli2.jsonc",
          ".markdownlint-cli2.yaml",
          ".markdownlint-cli2.cjs",
          ".markdownlint-cli2.mjs",
          ".markdownlint.jsonc",
          ".markdownlint.json",
          ".markdownlint.yaml",
          ".markdownlint.yml",
        }
        local has_config = vim.fs.find(config_files, { path = ctx.filename, upward = true })[1] ~= nil

        return has_config
      end,
    }

    -- Умный конфиг для PHP (phpcs)
    opts.linters.phpcs = {
      -- ГЛАВНОЕ: Линтер запустится только если вернет true
      cmd = "/home/yaubara/.config/composer/vendor/bin/phpcs",
      condition = function(ctx)
        local bufname = ctx.filename or vim.api.nvim_buf_get_name(0)
        local home = vim.uv.os_homedir()
        -- Проверяем наличие маркеров проекта
        local has_config = vim.fs.find(
          { "phpcs.xml", "phpcs.xml.dist", ".phpcs.xml", ".phpcs.xml.dist" },
          { path = bufname, upward = true, stop = home }
        )[1] ~= nil

        return has_config
      end,

      args = {
        "-q",
        "--report=json",
        "-",
      },
    }

    return opts
  end,
}
