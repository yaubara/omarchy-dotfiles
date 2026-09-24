-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local last_layout = "0" -- По умолчанию EN

-- Функция для тихого переключения и обновления статусбара
local function switch_and_notify(layout)
  -- 1. Переключаем раскладку в Hyprland
  vim.loop.spawn("hyprctl", { args = { "switchxkblayout", "all", layout } }, nil)
  -- 2. Посылаем сигнал твоему скрипту (pkill)
  vim.loop.spawn("pkill", { args = { "-f", "-SIGRTMIN+1", "get_keyboard_layout.sh" } }, nil)
end

local function get_current_layout()
  local handle = io.popen("hyprctl devices -j")
  local result = handle:read("*a")
  handle:close()

  -- Декодируем JSON (в Neovim есть встроенная функция)
  local data = vim.fn.json_decode(result)

  -- Ищем клавиатуру, которая сейчас активна
  for _, keyboard in ipairs(data.keyboards) do
    if keyboard.main then -- Hyprland помечает основную клавиатуру
      return keyboard.active_keymap
    end
  end
  return "English"
end

vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    -- Сбрасываем на английский при входе в окно терминала
    switch_and_notify("0")
  end,
})

-- Автокоманда при выходе из Insert Mode
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    local layout = get_current_layout()

    -- Проверяем конкретно имя активной раскладки
    if layout:find("Russian") or layout:find("ru") then
      last_layout = "1"
    else
      last_layout = "0"
    end

    -- Ставим EN (0) для Normal Mode и уведомляем систему
    switch_and_notify("0")
  end,
})

-- Автокоманда при входе в Insert Mode
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    -- Возвращаем сохраненную раскладку
    switch_and_notify(last_layout)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "txt", "text" },
  callback = function()
    vim.opt_local.spell = false
    -- Опционально оставляем перенос строк (wrap), если он нужен
    vim.opt_local.wrap = true
  end,
})

local lsp_hacks = vim.api.nvim_create_augroup("LspHacks", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = lsp_hacks,
  pattern = ".env*",
  callback = function(e)
    vim.diagnostic.enable(false, { bufnr = e.buf })
  end,
})
