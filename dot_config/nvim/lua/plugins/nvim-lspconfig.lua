-- stylua: ignore
local intelephense_stubs = {
    'apache', 'bcmath', 'bz2', 'calendar', 'com_dotnet', 'Core', 'ctype', 'curl', 'date', 'dba', 'dom', 'enchant',
    'exif', 'FFI', 'fileinfo', 'filter', 'fpm', 'ftp', 'gd', 'gettext', 'gmp', 'hash', 'iconv', 'imap', 'intl', 'json',
    'ldap', 'libxml', 'mbstring', 'meta', 'mysqli', 'oci8', 'odbc', 'openssl', 'pcntl', 'pcre', 'PDO', 'pdo_ibm',
    'pdo_mysql', 'pdo_pgsql', 'pdo_sqlite', 'pgsql', 'Phar', 'posix', 'pspell', 'readline', 'Reflection', 'session',
    'shmop', 'SimpleXML', 'snmp', 'soap', 'sockets', 'sodium', 'SPL', 'sqlite3', 'standard', 'superglobals', 'sysvmsg',
    'sysvsem', 'sysvshm', 'tidy', 'tokenizer', 'xml', 'xmlreader', 'xmlrpc', 'xmlwriter', 'xsl', 'Zend OPcache', 'zip',
    'zlib'
}

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- FIXME: doesn't work
      lemminx = {
        cmd = { "lemminx" },
        filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
        end,
        single_file_support = true,
      },
      emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "pug",
          "typescriptreact",
        },
      },
      codebook = {
        cmd = { "codebook-lsp", "serve" },
        -- stylua: ignore
        filetypes = {
          "c", "css", "go", "html", "javascript", "lua", "markdown",
          "php", "python", "rust", "typescript", "vue", "text"
        },
      },
    },
  },
  -- FIXME: Config overrides opts. Hope i will not need this
  --
  -- config = function(_, _)
  --   local lspconfig = require("lspconfig")
  --
  --   -- Only Wordpress
  --   lspconfig.intelephense.setup({
  --     root_dir = function(fname)
  --       return lspconfig.util.root_pattern("wp-config.php")(fname)
  --     end,
  --     settings = {
  --       intelephense = {
  --         filetypes = { "php", "php.wp" },
  --         stubs = intelephense_stubs,
  --         files = { maxSize = 5000000 },
  --       },
  --     },
  --   })
  --
  --   -- Modern PHP & Not Wordpress
  --   lspconfig.phpactor.setup({
  --     root_dir = function(fname)
  --       if lspconfig.util.root_pattern("wp-config.php")(fname) then
  --         return nil
  --       end
  --
  --       local home = vim.uv.os_homedir()
  --       local project_root = lspconfig.util.root_pattern("artisan", "composer.json")(fname)
  --       if project_root then
  --         return project_root
  --       end
  --
  --       local git_root = lspconfig.util.root_pattern(".git")(fname)
  --       if git_root and git_root ~= home then
  --         return git_root
  --       end
  --
  --       return vim.fs.dirname(fname)
  --     end,
  --   })
  -- end,
}
